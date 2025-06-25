SELECT
  id,
  asset_id,
  schedule_type,
  depreciation_date,
  current_year_dep,
  accum_dep
FROM depreciation
ORDER BY depreciation_date DESC;
