// src/app/api/ping/route.ts
import { pool } from '@/lib/database'

export async function GET() {
  console.log('🏓 ping handler hit')
  const { rows } = await pool.query('SELECT NOW()')
  return new Response(JSON.stringify(rows[0]), {
    headers: { 'Content-Type': 'application/json' },
  })
}
