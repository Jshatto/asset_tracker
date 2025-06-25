// src/lib/services/importAssets.ts
import { pool } from '@/lib/database'
import type { AssetImport } from 'src/types/asset'

/**
 * Bulk-inserts new assets into the database.
 * @param assets - array of AssetImport objects
 * @returns number of rows inserted
 */
export async function importAssets(assets: AssetImport[]): Promise<{ inserted: number }> {
  if (assets.length === 0) {
    return { inserted: 0 }
  }

  // Build a single parameterized INSERT for all rows
  // e.g. INSERT INTO assets(asset_name,purchase_date,purchase_price,useful_life,category) VALUES ($1,$2,$3,$4,$5),($6,$7,$8,$9,$10),...
  const columns = ['asset_name','purchase_date','purchase_price','depreciation method','useful_life_years','section_179_election','section_179_amount','bonus_depreciation_election','accumulated_tax_depreciation','accumulated_book_depreciation','category','asset_status']
  const valuesClause = assets
    .map((_, i) => {
      const offset = i * columns.length
      const params = columns.map((_, j) => `$${offset + j + 1}`)
      return `(${params.join(',')})`
    })
    .join(',')

  const sql = `
    INSERT INTO assets(${columns.join(',')})
    VALUES ${valuesClause}
  `

  // Flatten all values into one array
  const flatValues = assets.flatMap(a => columns.map(col => (a as any)[col]))

  await pool.query(sql, flatValues)
  return { inserted: assets.length }
}
