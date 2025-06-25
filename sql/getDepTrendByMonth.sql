-- getDepTrendByMonth (current‐year only)
WITH monthly AS (
  SELECT
    DATE_TRUNC('month', depreciation_date)::DATE AS period,
    SUM(current_year_dep)                        AS this_period
  FROM v_tax_depreciation
  WHERE DATE_TRUNC('year', depreciation_date) = DATE_TRUNC('year', CURRENT_DATE)
  GROUP BY 1
)
SELECT
  TO_CHAR(period, 'YYYY-MM')     AS period,
  this_period,
  LAG(this_period) OVER (ORDER BY period) AS prior_period
FROM monthly
ORDER BY period;
