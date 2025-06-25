WITH assets_cte AS (
  SELECT
    a.purchase_price       AS cost,
    a.useful_life_years    AS life,
    EXTRACT(YEAR FROM a.purchase_date)               AS placed_year,
    LEAST(
      EXTRACT(YEAR FROM AGE(NOW(), a.purchase_date)) + 1,
      a.useful_life_years
    )                                               AS curr_yr_service,
    LEAST(
      EXTRACT(YEAR FROM AGE(NOW(), a.purchase_date)),
      a.useful_life_years
    )                                               AS yrs_in_service
  FROM assets a
  WHERE
    ({{ getClientMapping.currentClientId ?? 0 }} = 0
      OR a.client_id = {{ getClientMapping.currentClientId }})
    AND a.asset_status = 'Active'
),
macrs_accum AS (
  SELECT SUM(ac.cost * m.rate)               AS amt
  FROM assets_cte ac
  JOIN macrs_rates m
    ON m.recovery_period_years = ac.life
   AND m.year_in_service      <= ac.yrs_in_service
),
bonus_accum AS (
  SELECT SUM(ac.cost * COALESCE(b.bonus_rate,0)) AS amt
  FROM assets_cte ac
  LEFT JOIN bonus_depreciation b
    ON b.tax_year = ac.placed_year
),
s179_accum AS (
  SELECT SUM(
    LEAST(COALESCE(l.deduction_limit,0), ac.cost)
  )                                           AS amt
  FROM assets_cte ac
  LEFT JOIN section179_limits l
    ON l.tax_year = ac.placed_year
),
macrs_curr AS (
  SELECT SUM(ac.cost * m.rate)               AS amt
  FROM assets_cte ac
  JOIN macrs_rates m
    ON m.recovery_period_years = ac.life
   AND m.year_in_service       = ac.curr_yr_service
),
bonus_curr AS (
  SELECT SUM(
    CASE WHEN ac.placed_year = EXTRACT(YEAR FROM NOW())
         THEN ac.cost * COALESCE(b.bonus_rate,0)
         ELSE 0 END
  )                                           AS amt
  FROM assets_cte ac
  LEFT JOIN bonus_depreciation b
    ON b.tax_year = ac.placed_year
),
s179_curr AS (
  SELECT SUM(
    CASE WHEN ac.placed_year = EXTRACT(YEAR FROM NOW())
         THEN LEAST(COALESCE(l.deduction_limit,0), ac.cost)
         ELSE 0 END
  )                                           AS amt
  FROM assets_cte ac
  LEFT JOIN section179_limits l
    ON l.tax_year = ac.placed_year
)
SELECT
  /* totals to date */
  COALESCE(macrs_accum.amt,0)
  + COALESCE(bonus_accum.amt,0)
  + COALESCE(s179_accum.amt,0)                AS accumulated_tax_total,
  /* this year */
  COALESCE(macrs_curr.amt,0)
  + COALESCE(bonus_curr.amt,0)
  + COALESCE(s179_curr.amt,0)                 AS current_year_tax_total
FROM macrs_accum, bonus_accum, s179_accum, macrs_curr, bonus_curr, s179_curr;
