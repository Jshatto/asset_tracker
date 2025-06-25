SELECT
  COALESCE(
    SUM(
      a.purchase_price
      / NULLIF(a.useful_life_years, 0)
    ),
    0
  ) AS current_year_book_dep
FROM assets a
WHERE
  -- client filter
  ({{ getClientMapping.currentClientId ?? 0 }} = 0
    OR a.client_id = {{ getClientMapping.currentClientId }})
  AND a.asset_status = 'Active'
  -- still in service this year
  AND EXTRACT(
        YEAR
        FROM AGE(NOW(), a.purchase_date)
      ) < a.useful_life_years;
