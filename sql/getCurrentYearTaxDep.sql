WITH assets_cte AS (
  SELECT
    a.id                    AS asset_id,
    a.purchase_price        AS cost,
    a.useful_life_years     AS life,
    EXTRACT(YEAR FROM a.purchase_date) AS placed_year,
    /* service count INCLUDING current year */
    LEAST(
      EXTRACT(YEAR FROM AGE(NOW(), a.purchase_date)) + 1,
      a.useful_life_years
    )                        AS curr_yr_service
  FROM assets a
  WHERE
    ({{ getClientMapping.currentClientId ?? 0 }} = 0
      OR a.client_id = {{ getClientMapping.currentClientId }})
    AND a.asset_status = 'Active'
    AND EXTRACT(YEAR FROM AGE(NOW(), a.purchase_date)) < a.useful_life_years
)
SELECT
  /* MACRS for this service year */
  COALESCE(SUM(ac.cost * m.rate),0)
  /* PLUS Bonus if placed this year */
  + COALESCE(SUM(
      ac.cost
      * COALESCE(b.bonus_rate,0)
      * CASE WHEN ac.placed_year = EXTRACT(YEAR FROM NOW()) THEN 1 ELSE 0 END
    ),0)
  /* PLUS §179 if placed this year */
  + COALESCE(SUM(
      CASE WHEN ac.placed_year = EXTRACT(YEAR FROM NOW())
        THEN LEAST(COALESCE(l.deduction_limit,0), ac.cost)
        ELSE 0
      END
    ),0)
  AS current_year_tax_dep
FROM assets_cte ac
LEFT JOIN macrs_rates m
  ON m.recovery_period_years = ac.life
 AND m.year_in_service       = ac.curr_yr_service
LEFT JOIN bonus_depreciation b
  ON b.tax_year = ac.placed_year
LEFT JOIN section179_limits l
  ON l.tax_year = ac.placed_year;
