UPDATE assets SET 
    asset_name = {{ edit_asset_form.data.assetName}},
  purchase_price = {{ edit_asset_form.data.purchase_price }},
  purchase_date = {{ edit_asset_form.data.purchase_date }},
  category = {{ edit_asset_form.data.category }},
  useful_life_years = {{ edit_asset_form.data.useful_life_years }},
  asset_status = {{ edit_asset_form.data.asset_status}},
  depreciation_method = {{ edit_asset_form.data.depreciation_method }},
  section_179_election = {{ edit_asset_form.data.section_179}},
  section_179_amount = {{ edit_asset_form.data.amount_179 }},
  bonus_depreciation_election = {{ edit_asset_form.data.bonus_depreciation }},
    accumulated_tax_depreciation =  {{ edit_asset_form.data.accumulated_tax_depreciation }},
      accumulated_book_depreciation = {{ edit_asset_form.data.accumulated_book_depreciation }}
      WHERE id = {{ assetTable_Main.selectedSourceRow }}
RETURNING *;