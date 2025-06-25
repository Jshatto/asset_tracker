-- costToDateCurr
SELECT COALESCE(SUM(purchase_price),0) AS total
FROM assets
WHERE EXTRACT(YEAR FROM purchase_date) <= EXTRACT(YEAR FROM CURRENT_DATE);
