WITH raw AS (
  SELECT *
  FROM json_populate_recordset(
    NULL::section179_limits,
    {{ JSON.stringify(fileDropzone179.parsedValue?.[0] || []) }}::json
  )
)
INSERT INTO section179_limits (tax_year, deduction_limit, phaseout_threshold)
SELECT
  tax_year::integer,
  deduction_limit::numeric,
  phaseout_threshold::numeric
FROM raw
ON CONFLICT (tax_year)
  DO UPDATE SET deduction_limit = EXCLUDED.deduction_limit
RETURNING *;
