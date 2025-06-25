SELECT 
  id,
  asset_name,
  client_id,
  CASE WHEN client_id IS NULL THEN 'No Client Assigned' ELSE CONCAT('Client ', client_id) END as client_assignment
FROM assets
ORDER BY client_id;