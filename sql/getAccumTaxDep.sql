WITH assets_cte AS (
  SELECT
    a.id                    AS asset_id,
    a.purchase_price        AS cost,
    a.useful_life_years     AS life,
    EXTRACT(YEAR FROM a.purchase_date) AS placed_year,
    LEAST(
      EXTRACT(YEAR FROM AGE(NOW(), a.purchase_date)),
      a.useful_life_years
    )                        AS yrs_in_service
  FROM assets a
  WHERE
    ({{ getClientMapping.currentClientId ?? 0 }} = 0
      OR a.client_id = {{ getClientMapping.currentClientId }})
    AND a.asset_status = 'Active'
),
macrs_cte AS (
  SELECT asset_id, cost * m.rate     AS amt
  FROM assets_cte ac
  JOIN macrs_rates m
    ON m.recovery_period_years = ac.life
   AND m.year_in_service       = ac.yrs_in_service
),
bonus_cte AS (
  SELECT asset_id, cost * COALESCE(b.bonus_rate,0) AS amt
  FROM assets_cte ac
  LEFT JOIN bonus_depreciation b
    ON b.tax_year = ac.placed_year
),
s179_cte AS (
  SELECT asset_id,
    LEAST(COALESCE(l.deduction_limit,0), cost) AS amt
  FROM assets_cte ac
  LEFT JOIN section179_limits l
    ON l.tax_year = ac.placed_year
),
combined AS (
  SELECT asset_id,
    COALESCE(SUM(macrs_cte.amt),0)
    + COALESCE(SUM(bonus_cte.amt),0)
    + COALESCE(SUM(s179_cte.amt),0) AS total_amt
  FROM assets_cte ac
  LEFT JOIN macrs_cte    ON ac.asset_id = macrs_cte.asset_id
  LEFT JOIN bonus_cte    ON ac.asset_id = bonus_cte.asset_id
  LEFT JOIN s179_cte     ON ac.asset_id = s179_cte.asset_id
  GROUP BY ac.asset_id
)
SELECT
  COALESCE(SUM(total_amt),0) AS accumulated_tax_dep
FROM combined;
