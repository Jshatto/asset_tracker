-- insertDepreciation
INSERT INTO depreciation (
  asset_id,
  schedule_type,
  depreciation_date,
  current_year_dep,
  accum_dep
) VALUES (
  {{ row.asset_id }},
  {{ row.schedule_type }},
  {{ row.depreciation_date }},
  {{ row.current_year_dep }},
  {{ row.accum_dep }}
)
ON CONFLICT (asset_id, schedule_type, depreciation_date)
DO UPDATE SET
  current_year_dep = EXCLUDED.current_year_dep,
  accum_dep        = EXCLUDED.accum_dep;
