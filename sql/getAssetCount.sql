SELECT 
  COUNT(*) AS total_assets
FROM assets a
WHERE
  ({{ getClientMapping.currentClientId ?? 0 }} = 0
    OR a.client_id = {{ getClientMapping.currentClientId }})
  AND a.asset_status = 'Active'

