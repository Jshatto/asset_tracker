-- Query name: getAccumTaxDepPctChange
WITH curr AS (
  SELECT COALESCE(SUM(accum_dep),0) AS total
  FROM v_tax_depreciation
  WHERE EXTRACT(YEAR FROM depreciation_date) <= EXTRACT(YEAR FROM CURRENT_DATE)
),
prev AS (
  SELECT COALESCE(SUM(accum_dep),0) AS total
  FROM v_tax_depreciation
  WHERE EXTRACT(YEAR FROM depreciation_date) <= EXTRACT(YEAR FROM CURRENT_DATE) - 1
)
SELECT
  CASE 
    WHEN prev.total = 0 THEN NULL
    ELSE ROUND((curr.total - prev.total) / prev.total * 100, 2)
  END AS pct_change
FROM curr, prev;
