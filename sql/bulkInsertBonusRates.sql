-- 1) JSON → recordset
WITH raw AS (
  SELECT *
  FROM json_populate_recordset(
    NULL::bonus_depreciation,
    {{ JSON.stringify(fileDropzoneBonus.parsedValue?.[0] || []) }}::json
  )
)
-- 2) upsert into your real table
INSERT INTO bonus_depreciation (tax_year, bonus_rate)
SELECT
  tax_year::integer,
  bonus_rate::numeric
FROM raw
ON CONFLICT (tax_year)
  DO UPDATE SET bonus_rate = EXCLUDED.bonus_rate
RETURNING *;
