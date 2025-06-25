SELECT
  COALESCE(SUM(a.purchase_price), 0) AS total_value
FROM assets a
WHERE
  -- client filter (0 = all clients)
  ({{ getClientMapping.currentClientId ?? 0 }} = 0
    OR a.client_id = {{ getClientMapping.currentClientId }})
  -- only active assets
  AND a.asset_status = 'Active'

  
