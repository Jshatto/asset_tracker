// src/lib/services/populateDepreciation.ts
import { pool } from '../database'
import { calculateBookDepreciation } from './calculateBookDepreciation'
import { calculateTaxDepreciation }  from './calculateTaxDepreciation'
import type { BookRow, TaxRow }     from 'src/types/depreciation'

/**
 * Pulls rows from both depreciation views and 
 * truncates & bulk‐inserts them into the depreciation table.
 */
export async function populateDepreciation(): Promise<{ inserted: number }> {
  // 1️⃣ fetch both sets of data
  const bookRows = await calculateBookDepreciation()
  const taxRows  = await calculateTaxDepreciation()

  if (bookRows.length === 0 && taxRows.length === 0) {
    return { inserted: 0 }
  }

  // 2️⃣ clear out old data
  await pool.query('TRUNCATE TABLE depreciation')

  // 3️⃣ bulk insert BOOK rows
if (bookRows.length > 0) {
  const cols = [
    'asset_id',
    'depreciation_date',
    'schedule_type',
    'accum_dep',
    'bonus_amt',
    'current_year_dep',
  ]
  const valuesClause = bookRows
    .map((_, i) => {
      const offset = i * cols.length
      const params = cols.map((_, j) => `$${offset + j + 1}`)
      return `(${params.join(',')})`
    })
    .join(',')

  const sql = `
    INSERT INTO depreciation(${cols.join(',')})
    VALUES ${valuesClause}
  `

  // No generics here—TS will infer an (string|number)[] for us
  const flatValues: (string | number)[] = bookRows.flatMap(r => [
    r.asset_id,
    r.depreciation_date,
    'book',           // schedule_type
    r.accum_dep,
    0,                // bonus_amt = 0 for book
    r.current_year_dep,
  ])

  await pool.query(sql, flatValues)
}

// 4️⃣ bulk insert TAX rows
if (taxRows.length > 0) {
  const cols = [
    'asset_id',
    'depreciation_date',
    'schedule_type',
    'accum_dep',
    'bonus_amt',
    'current_year_dep',
  ]
  const valuesClause = taxRows
    .map((_, i) => {
      const offset = i * cols.length
      const params = cols.map((_, j) => `$${offset + j + 1}`)
      return `(${params.join(',')})`
    })
    .join(',')

  const sql = `
    INSERT INTO depreciation(${cols.join(',')})
    VALUES ${valuesClause}
  `

  const flatValues: (string | number)[] = taxRows.flatMap(r => [
    r.asset_id,
    r.depreciation_date,
    'tax',            // schedule_type
    r.accum_dep,
    0,                // bonus_amt = 0 for tax
    r.current_year_dep,
  ])

  await pool.query(sql, flatValues)
}

  // 5️⃣ report total rows inserted
  return { inserted: bookRows.length + taxRows.length }
}
