-- getDepreciationTrend
WITH raw AS (
  SELECT
    DATE_TRUNC('month', depreciation_date)::DATE AS period,
    current_year_dep
  FROM v_tax_depreciation
  WHERE depreciation_date >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '13 months'
),
this_year AS (
  SELECT
    period,
    SUM(current_year_dep) AS value
  FROM raw
  WHERE period >= DATE_TRUNC('year', CURRENT_DATE)
  GROUP BY period
),
last_year AS (
  SELECT
    (period + INTERVAL '1 year')::DATE AS period,
    SUM(current_year_dep) AS value
  FROM raw
  WHERE period >= DATE_TRUNC('year', CURRENT_DATE) - INTERVAL '1 year'
    AND period < DATE_TRUNC('year', CURRENT_DATE)
  GROUP BY period
)
SELECT
  COALESCE(t.period, l.period) AS period,
  COALESCE(t.value, 0) AS this_value,
  COALESCE(l.value, 0) AS last_value
FROM this_year t
FULL OUTER JOIN last_year l USING (period)
ORDER BY period;
