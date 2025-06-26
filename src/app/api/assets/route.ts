// src/app/api/assets/route.ts
import fs from 'fs'
import path from 'path'
import { pool } from '@/lib/database'
import type { Asset } from '@/types/asset'

const sql = fs.readFileSync(
  path.resolve(process.cwd(), 'sql', 'getAssetList.sql'),
  'utf-8'
)

export async function GET() {
  try {
    const { rows } = await pool.query<Asset>(sql)
    return new Response(JSON.stringify(rows), {
      headers: { 'Content-Type': 'application/json' },
    })
  } catch (err: any) {
    console.error('❌ GET /api/assets error:', err)
    return new Response(err.message, { status: 500 })
  }
}
