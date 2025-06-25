INSERT INTO assets (
  asset_name, 
  purchase_price, 
  purchase_date, 
  depreciation_start,
  category, 
  useful_life_years,
  asset_status,
  depreciation_method,
  macrs_class_life,
  placed_in_service_date,
  tax_depreciation_method,
  book_depreciation_method,
  section_179_election,
  bonus_depreciation_election,
  section_179_amount,
  client_id
)  VALUES (
  {{ form1.data.asset_name }},
  {{ form1.data.purchase_price }},
  {{ form1.data.purchase_date }},
  {{ form1.data.purchase_date }},
  {{ form1.data.category }},
  {{ form1.data.useful_life_years }},
  {{ form1.data.asset_status }},
  {{ form1.data.depreciation_method }},
  {{ form1.data.macrs_class_life || 5 }},
  {{ form1.data.placed_in_service_date || form1.data.purchase_date }},
  {{ form1.data.tax_depreciation_method || 'MACRS' }},
  {{ form1.data.book_depreciation_method || 'Straight-Line' }},
  {{ form1.data.section_179_election || false }},
  {{ form1.data.bonus_depreciation_election || false }},
  {{ form1.data.section_179_election ? (form1.data.section_179_amount || form1.data.purchase_price) : 0 }},
   {{ getClientMapping.data.currentClientId 
  }}



) RETURNING *;