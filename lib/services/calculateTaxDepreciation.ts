// src/lib/services/calculateTaxDepreciation.ts
import { pool } from '../database'
import type { TaxRow } from 'src/types/depreciation'
import { readFileSync } from 'fs'
import path from 'path'

const raw = readFileSync(
  path.resolve('sql/v_tax_depreciation.sql'),
  'utf-8'
)

export async function calculateTaxDepreciation(): Promise<TaxRow[]> {
  // pull the raw rows, which have `id` not `asset_id`
  const { rows } = await pool.query<{ id: number; depreciation_date: string; current_year_dep: number; accum_dep: number }>(raw)

  // map each `id` → `asset_id`
  return rows.map(r => ({
    asset_id: r.id,
    depreciation_date: r.depreciation_date,
    current_year_dep: r.current_year_dep,
    accum_dep: r.accum_dep,
  }))
}
