-- accumTaxDepThisYear
SELECT COALESCE(SUM(accum_dep),0) AS total
FROM v_tax_depreciation
WHERE EXTRACT(YEAR FROM depreciation_date) <= EXTRACT(YEAR FROM CURRENT_DATE);
