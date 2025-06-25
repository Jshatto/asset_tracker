-- getDepTrendByYear
SELECT
  EXTRACT(YEAR FROM depreciation_date)::INT AS year,
  SUM(current_year_dep)                    AS dep_amount
FROM v_tax_depreciation
GROUP BY 1
ORDER BY 1;
