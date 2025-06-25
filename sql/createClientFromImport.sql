-- ensure you have a UNIQUE constraint on tax_id first:
-- ALTER TABLE clients ADD CONSTRAINT clients_tax_id_unique UNIQUE (tax_id);

INSERT INTO clients (
  client_name,
  email,
  phone,
  address,
  entity_type,
  tax_id,
  return_type,
  last_filing_date
) VALUES (
  {{ importRow.client_name }},
  {{ importRow.email }},
  {{ importRow.phone }},
  {{ importRow.address }},
  {{ importRow.entity_type }},
  {{ importRow.tax_id }},
  {{ importRow.return_type }},
  {{ importRow.last_filing_date }}
)
ON CONFLICT (tax_id) DO UPDATE
SET
  client_name      = EXCLUDED.client_name,
  email            = EXCLUDED.email,
  phone            = EXCLUDED.phone,
  address          = EXCLUDED.address,
  entity_type      = EXCLUDED.entity_type,
  return_type      = EXCLUDED.return_type,
  last_filing_date = EXCLUDED.last_filing_date
RETURNING *;
