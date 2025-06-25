-- getAssetValueBaseYear
SELECT
  DATE_TRUNC('month', purchase_date)::DATE AS month_date,
  SUM(purchase_price)                       AS total_cost
FROM assets
WHERE EXTRACT(YEAR FROM purchase_date) = {{ baseYear.value }}
GROUP BY 1
ORDER BY 1;
