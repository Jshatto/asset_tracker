-- calculateTaxDepreciation
WITH elect AS (
  SELECT
    a.id                                 AS asset_id,
    COALESCE(a.section_179_amount, 0)    AS sec179_amt,
    COALESCE(a.bonus_amount,      0)     AS bonus_amount,
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
    e.sec179_amt,
    e.bonus_amount,
    r.year_in_service,
    r.rate,
    -- each service-year’s depreciation anniversary
    (e.depreciation_start + (r.year_in_service - 1) * INTERVAL '1 year')::DATE
      AS depreciation_date
  FROM elect e
  JOIN macrs_rates r
    ON r.recovery_period_years = e.useful_life
),

calc AS (
  SELECT
    m.asset_id,
    m.depreciation_date,
    -- Section 179 in year 1
    CASE WHEN m.year_in_service = 1
      THEN LEAST(m.sec179_amt, m.purchase_price)
      ELSE 0
    END AS sec179_dep,
    -- Bonus as a fixed dollar in year 1
    CASE WHEN m.year_in_service = 1
      THEN LEAST(m.bonus_amount, m.purchase_price - LEAST(m.sec179_amt, m.purchase_price))
      ELSE 0
    END AS bonus_dep,
    -- MACRS on the remaining basis
    GREATEST(
      m.purchase_price
      - LEAST(m.sec179_amt, m.purchase_price)
      - LEAST(m.bonus_amount, m.purchase_price - LEAST(m.sec179_amt, m.purchase_price)),
      0
    ) * m.rate AS macrs_dep
  FROM macrs m
)

SELECT
  asset_id,
  depreciation_date,
  ROUND(sec179_dep + bonus_dep + macrs_dep, 2) AS current_year_dep,
  SUM(ROUND(sec179_dep + bonus_dep + macrs_dep, 2))
    OVER (PARTITION BY asset_id ORDER BY depreciation_date)
    AS accum_dep
FROM calc
ORDER BY asset_id, depreciation_date;
