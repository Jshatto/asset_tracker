-- Query name: getNetBookPctChange
WITH cost_curr AS (
  SELECT COALESCE(SUM(purchase_price),0) AS total_cost
  FROM assets
  WHERE EXTRACT(YEAR FROM purchase_date) <= EXTRACT(YEAR FROM CURRENT_DATE)
),
accum_curr AS (
  SELECT COALESCE(SUM(accum_dep),0) AS total_accum
  FROM v_book_depreciation
  WHERE EXTRACT(YEAR FROM depreciation_date) <= EXTRACT(YEAR FROM CURRENT_DATE)
),
cost_prev AS (
  SELECT COALESCE(SUM(purchase_price),0) AS total_cost
  FROM assets
  WHERE EXTRACT(YEAR FROM purchase_date) <= EXTRACT(YEAR FROM CURRENT_DATE) - 1
),
accum_prev AS (
  SELECT COALESCE(SUM(accum_dep),0) AS total_accum
  FROM v_book_depreciation
  WHERE EXTRACT(YEAR FROM depreciation_date) <= EXTRACT(YEAR FROM CURRENT_DATE) - 1
),
curr AS (
  SELECT (c.total_cost - a.total_accum) AS net_book
  FROM cost_curr c, accum_curr a
),
prev AS (
  SELECT (c.total_cost - a.total_accum) AS net_book
  FROM cost_prev c, accum_prev a
)
SELECT
  CASE
    WHEN prev.net_book = 0 THEN NULL
    ELSE ROUND((curr.net_book - prev.net_book) / prev.net_book * 100, 2)
  END AS pct_change
FROM curr, prev;
