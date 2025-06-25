SELECT
  COALESCE(
    SUM(
      (
        a.purchase_price
        / NULLIF(a.useful_life_years, 0)
      )
      * LEAST(
          EXTRACT(YEAR FROM AGE(NOW(), a.purchase_date)),
          a.useful_life_years
        )
    ),
    0
  ) AS accumulated_book_dep
FROM assets a
WHERE
  ({{ getClientMapping.currentClientId ?? 0 }} = 0
    OR a.client_id = {{ getClientMapping.currentClientId }})
  AND a.asset_status = 'Active';
