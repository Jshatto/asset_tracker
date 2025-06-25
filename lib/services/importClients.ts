// src/lib/services/importClients.ts
import { pool } from '@/lib/database'
import type { ClientImport } from 'src/types/clients'

/**
 * Bulk-inserts new clients into the database.
 */
export async function importClients(
  clients: ClientImport[]
): Promise<{ inserted: number }> {
  if (clients.length === 0) return { inserted: 0 }

  const columns = ['client_name', 'email','phone','address','entity_type','tax_id','return_type','last_filing_date']  // adjust to your real columns
  const valuesClause = clients
    .map((_, i) => {
      const offset = i * columns.length
      const params = columns.map((_, j) => `$${offset + j + 1}`)
      return `(${params.join(',')})`
    })
    .join(',')

  const sql = `
    INSERT INTO clients(${columns.join(',')})
    VALUES ${valuesClause}
  `
  const flatValues = clients.flatMap(c => columns.map(col => (c as any)[col]))

  await pool.query(sql, flatValues)
  return { inserted: clients.length }
}
