SELECT
  a.id                                AS asset_id,
  a.asset_name,
  a.purchase_date,
  a.purchase_price                    AS original_cost,
  a.useful_life_years                 AS useful_life,
  LEAST(
    EXTRACT(YEAR FROM AGE(NOW(), a.purchase_date)),
    a.useful_life_years
  )                                    AS yrs_in_service,
  -- straight-line depreciation to date
  (
    a.purchase_price
    / NULLIF(a.useful_life_years, 0)
  ) * LEAST(
        EXTRACT(YEAR FROM AGE(NOW(), a.purchase_date)),
        a.useful_life_years
      )                                AS book_depreciation_to_date,
  -- straight-line depreciation for current year
  CASE
    WHEN EXTRACT(YEAR FROM AGE(NOW(), a.purchase_date)) < a.useful_life_years
    THEN a.purchase_price / NULLIF(a.useful_life_years, 0)
    ELSE 0
  END                                  AS book_depreciation_this_year,
  -- KPI totals (same on every row)
  SUM(
    CASE
      WHEN EXTRACT(YEAR FROM AGE(NOW(), a.purchase_date)) < a.useful_life_years
      THEN a.purchase_price / NULLIF(a.useful_life_years, 0)
      ELSE 0
    END
  ) OVER ()                           AS current_year_book_total,
  SUM(
    (
      a.purchase_price
      / NULLIF(a.useful_life_years, 0)
    ) * LEAST(
          EXTRACT(YEAR FROM AGE(NOW(), a.purchase_date)),
          a.useful_life_years
        )
  ) OVER ()                           AS accumulated_book_total
FROM assets a
WHERE
  -- client filter
  ({{ getClientMapping.currentClientId ?? 0 }} = 0
    OR a.client_id = {{ getClientMapping.currentClientId }})
  AND a.asset_status = 'Active'
  -- optional date range

ORDER BY a.purchase_date DESC;
