SELECT 
  COUNT(*) AS active_count
FROM assets
WHERE 
  asset_status = 'Active'
  AND (
    {{ getClientMapping.data.currentClientId === 0 }} 
    OR client_id = {{ getClientMapping.data.currentClientId }}
  );
