// src/lib/services/calculateTaxDepreciation.ts
import fs from 'fs'
import path from 'path'
import { pool } from '../database'
import type { TaxRow } from '../../types/depreciation'

/**
 * Runs the v_tax_depreciation view and returns one row per asset/year.
 */
export async function calculateTaxDepreciation(): Promise<TaxRow[]> {
  // 1️⃣ Load your SQL view definition
  const sqlPath = path.resolve(process.cwd(), 'sql', 'v_tax_depreciation.sql')
  const rawSql = fs.readFileSync(sqlPath, 'utf-8')

  // 2️⃣ Execute it against the database
  const { rows } = await pool.query<{
    id: number
    depreciation_date: string
    current_year_dep: number
    accum_dep: number
  }>(rawSql)

  // 3️⃣ Map id → asset_id if needed by your TaxRow type
  return rows.map(r => ({
    asset_id: r.id,
    depreciation_date: r.depreciation_date,
    current_year_dep: r.current_year_dep,
    accum_dep: r.accum_dep,
  }))
}
