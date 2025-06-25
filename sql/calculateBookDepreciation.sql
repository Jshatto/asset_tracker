SELECT
  COALESCE(SUM(purchase_price / useful_life_years), 0) AS total_book_depreciation
FROM assets
WHERE
  asset_status = 'Active'
  AND (
    {{ getClientMapping.currentClientId === 0 }}
    OR client_id = {{ getClientMapping.currentClientId }}
  );
