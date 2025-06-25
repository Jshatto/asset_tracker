INSERT INTO assets (
  asset_name,
  purchase_price,
  purchase_date,
  category,
  useful_life_years,
  asset_status,
  tax_depreciation_method,
  book_depreciation_method,
  section_179_election,
  section_179_amount,
  bonus_depreciation_election,
  client_id
)
VALUES (
  {{ getClientMapping.asset_name }},
  {{ getClientMapping.purchase_price }},
  {{ getClientMapping.purchase_date }},
  {{ getClientMapping.category }},
  {{ getClientMapping.useful_life_years }},
  {{ getClientMapping.asset_status }},
  {{ getClientMapping.tax_depreciation_method }},
  {{ getClientMapping.book_depreciation_method }},
  {{ getClientMapping.section_179_election }},
  {{ getClientMapping.section_179_amount }},
  {{ getClientMapping.bonus_depreciation_election }},
  {{ getClientMapping.data.currentClientId }}
)
RETURNING *;
