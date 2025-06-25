SELECT
  a.id             AS asset_id,
  a.asset_name,
  a.category,
  a.purchase_date,
  a.purchase_price AS purchase_price,
  a.depreciation_method,
  a.useful_life_years AS useful_life,
  a.asset_status
FROM assets a
WHERE
  (
    {{ getClientMapping.currentClientId ?? 0 }} = 0
    OR a.client_id = {{ getClientMapping.currentClientId ?? 0 }}
  )
  AND a.asset_status = 'Active'
ORDER BY a.purchase_date DESC;
