// src/types/depreciation.ts

// The shape of each row coming from your v_book_depreciation view
export interface BookRow {
  asset_id: number
  depreciation_date: string   // ISO date
  current_year_dep: number
  accum_dep: number
}

// The shape of each row coming from your v_tax_depreciation view
export interface TaxRow {
  asset_id: number
  depreciation_date: string
  current_year_dep: number
  accum_dep: number
}

// The final shape we insert into your `depreciation` table:
export interface DepreciationRow {
  asset_id: number
  depreciation_date: string
  schedule_type: 'book' | 'tax'
  accum_dep: number
  bonus_amt: number           // zero when not applicable
  current_year_dep: number
}
