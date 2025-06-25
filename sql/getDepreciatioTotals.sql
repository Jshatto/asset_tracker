SELECT 
  COALESCE(SUM(accumulated_depreciation), 0) AS depreciation_amount
FROM assets
WHERE 
  ({{ getClientMapping.data.currentClientId === 0 }} 
   OR client_id = {{ getClientMapping.data.currentClientId }});
