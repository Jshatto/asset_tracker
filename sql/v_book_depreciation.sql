CREATE OR REPLACE VIEW v_book_depreciation AS
WITH elect AS (
  SELECT
    a.id                                  AS asset_id,
    a.purchase_price,
    COALESCE(a.depreciation_start, a.purchase_date) AS depreciation_start,
    a.useful_life
  FROM assets a
  WHERE a.asset_status = 'Active'
),

macrs AS (
  SELECT
    e.asset_id,
    e.purchase_price,
    e.useful_life,
    r.year_in_service,
    r.rate,
    -- one depreciation_date per year in service
    (e.depreciation_start
       + (r.year_in_service - 1) * INTERVAL '1 year'
    )::DATE AS depreciation_date
  FROM elect e
  JOIN macrs_rates r
    ON r.recovery_period_years = e.useful_life
),

calc AS (
  SELECT
    m.asset_id,
    m.depreciation_date,
    -- straight‐line: cost / useful life
    (m.purchase_price / m.useful_life) AS sl_dep
  FROM macrs m
)

SELECT
  asset_id,
  depreciation_date,
  ROUND(sl_dep, 2)    AS current_year_dep,
  SUM(ROUND(sl_dep,2))
    OVER (PARTITION BY asset_id ORDER BY depreciation_date)
      AS accum_dep
FROM calc
ORDER BY asset_id, depreciation_date;
