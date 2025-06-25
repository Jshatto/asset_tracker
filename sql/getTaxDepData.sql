WITH assets_cte AS (
  SELECT
    a.id                                AS asset_id,
    a.asset_name,
    a.purchase_date,
    a.purchase_price                    AS original_cost,
    a.useful_life_years                 AS useful_life,
    EXTRACT(YEAR FROM a.purchase_date)  AS placed_year,
    LEAST(
      EXTRACT(YEAR FROM AGE(NOW(), a.purchase_date)),
      a.useful_life_years
    )                                    AS yrs_in_service
  FROM assets a
  WHERE
    ({{ getClientMapping.currentClientId ?? 0 }} = 0
      OR a.client_id = {{ getClientMapping.currentClientId }})
    AND a.asset_status = 'Active'
),
macrs_cte AS (
  SELECT
    ac.asset_id,
    ac.original_cost * m.rate         AS macrs_amt
  FROM assets_cte ac
  JOIN macrs_rates m
    ON m.recovery_period_years = ac.useful_life
   AND m.year_in_service       = ac.yrs_in_service
),
bonus_cte AS (
  SELECT
    ac.asset_id,
    ac.original_cost * COALESCE(b.bonus_rate, 0) AS bonus_amt
  FROM assets_cte ac
  LEFT JOIN bonus_depreciation b
    ON b.tax_year = ac.placed_year
),
s179_cte AS (
  SELECT
    ac.asset_id,
    LEAST(
      COALESCE(l.deduction_limit, 0),
      ac.original_cost
    )                                   AS s179_amt
  FROM assets_cte ac
  LEFT JOIN section179_limits l
    ON l.tax_year = ac.placed_year
),
combined AS (
  SELECT
    ac.asset_id,
    COALESCE(m.macrs_amt,  0)           AS macrs_amt,
    COALESCE(b.bonus_amt,  0)           AS bonus_amt,
    COALESCE(s.s179_amt,   0)           AS s179_amt
  FROM assets_cte ac
  LEFT JOIN macrs_cte m   ON ac.asset_id = m.asset_id
  LEFT JOIN bonus_cte b   ON ac.asset_id = b.asset_id
  LEFT JOIN s179_cte  s   ON ac.asset_id = s.asset_id
)
SELECT
  ac.asset_id,
  ac.asset_name,
  ac.purchase_date,
  ac.original_cost,
  ac.useful_life,
  combined.macrs_amt,
  combined.bonus_amt,
  combined.s179_amt,
  -- total tax depreciation, per asset
  (combined.macrs_amt
   + combined.bonus_amt
   + combined.s179_amt)               AS total_tax_depreciation,
  -- KPI totals (same on every row)
  SUM(
    CASE
      WHEN ac.placed_year = EXTRACT(YEAR FROM NOW())
      THEN (combined.macrs_amt + combined.bonus_amt + combined.s179_amt)
      ELSE 0
    END
  ) OVER ()                          AS current_year_tax_total,
  SUM(
    combined.macrs_amt
    + combined.bonus_amt
    + combined.s179_amt
  ) OVER ()                          AS accumulated_tax_total
FROM assets_cte ac
LEFT JOIN combined ON ac.asset_id = combined.asset_id
ORDER BY ac.purchase_date DESC;
