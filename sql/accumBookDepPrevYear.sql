-- accumBookDepPrevYear
SELECT COALESCE(SUM(accum_dep),0) AS total
FROM v_book_depreciation
WHERE EXTRACT(YEAR FROM depreciation_date) <= EXTRACT(YEAR FROM CURRENT_DATE) - 1;
