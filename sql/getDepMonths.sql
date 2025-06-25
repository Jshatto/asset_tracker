-- Query name: getDepMonths
SELECT
  TO_CHAR(depreciation_date, 'YYYY-MM') AS month_value,
  TO_CHAR(depreciation_date, 'Mon YYYY') AS month_label
FROM v_tax_depreciation
GROUP BY 1,2
ORDER BY 1 DESC;
