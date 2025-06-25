-- 1) Turn the CSV rows into JSON rows
WITH raw AS (
  SELECT *
  FROM json_populate_recordset(
    NULL::macrs_rates,
    {{ JSON.stringify( fileDropzoneRates.parsedValue?.[0] || [] ) }}::json
  )
)

-- 2) Upsert in one shot
INSERT INTO macrs_rates (
  recovery_period_years,
  year_in_service,
  rate
)
SELECT
  recovery_period_years::integer,
  year_in_service::integer,
  rate::numeric
FROM raw
ON CONFLICT (recovery_period_years, year_in_service)
DO UPDATE SET
  rate = EXCLUDED.rate
RETURNING *;