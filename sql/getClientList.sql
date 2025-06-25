SELECT
  id,
  client_name,
  email,
  phone,
  address,
  entity_type,
  tax_id,
  return_type,
  last_filing_date  

FROM clients
ORDER BY client_name;
