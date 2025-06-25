-- get_DepYears
SELECT
  EXTRACT(YEAR 
    FROM depreciation_date
  )::INT AS year
FROM v_tax_depreciation
GROUP BY 1
ORDER BY 1 DESC;
