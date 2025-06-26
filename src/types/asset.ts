// src/types/asset.ts
export interface Asset {
  id: number
  asset_name: string
  purchase_date: string    // ISO date
  purchase_price: number
  useful_life: number
  category: string
  depreciation_method: string
  section_179_amount: string
  section_179_election: string
  bonus_depreciation_election: string
  accumulated_tax_depreciation: string
  accumulated_book_depreciation: string
  // add any extra fields you import
  [key: string]: any
}
