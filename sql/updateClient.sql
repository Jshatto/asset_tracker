UPDATE clients
SET
 
  client_name      = {{ formUpdateClient.data.client_name }},
  email            = {{ formUpdateClient.data.email }},
  phone            = {{ formUpdateClient.data.phone }},
  address          = {{ formUpdateClient.data.address }},
  entity_type      = {{ formUpdateClient.data.entity_type }},
  tax_id           = {{ formUpdateClient.data.tax_id }},
  return_type      = {{ formUpdateClient.data.return_type }},
  last_filing_date = {{ formUpdateClient.data.last_filing_date }}
WHERE id = {{ formUpdateClient.data.id }}
RETURNING *;
