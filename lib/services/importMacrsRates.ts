import { pool } from "../database"
import type { MacrsRateImport } from 'src/types/macrsRate'

// src/lib/services/importMacrsRates.ts
export async function importMacrsRates(
  rates: MacrsRateImport[]
): Promise<{ inserted: number }> {
  if (rates.length === 0) return { inserted: 0 }

  const columns = ['recovery_period_years','year_in_service','rate']
  const valuesClause = rates
    .map((_, i) => {
      const offset = i * columns.length
      const params = columns.map((_, j) => `$${offset + j + 1}`)
      return `(${params.join(',')})`
    })
    .join(',')

  // ON CONFLICT on the primary key columns
  const sql = `
    INSERT INTO macrs_rates(${columns.join(',')})
    VALUES ${valuesClause}
    ON CONFLICT (recovery_period_years, year_in_service)
    DO UPDATE SET rate = EXCLUDED.rate
  `
  const flatValues = rates.flatMap(r => columns.map(col => (r as any)[col]))

  await pool.query(sql, flatValues)
  return { inserted: rates.length }
}
