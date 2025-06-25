SELECT
  recovery_period_years,
  year_in_service,
  rate,
  CONCAT(recovery_period_years, '-', year_in_service) AS id
FROM macrs_rates
ORDER BY recovery_period_years, year_in_service;
