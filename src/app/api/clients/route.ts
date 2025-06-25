import { NextResponse } from 'next/server'
import { readFile } from 'fs/promises'
import { pool } from '@/lib/database'
import type { Client } from '@/types/client'

export const dynamic = 'force-dynamic'

export async function GET() {
  try {
    const sql = await readFile('sql/getClientList.sql', 'utf8')
    const { rows } = await pool.query<Client>(sql)
    return NextResponse.json(rows, { headers: { 'Content-Type': 'application/json' } })
  } catch (err) {
    console.error('Error fetching client list:', err)
    return new NextResponse('Internal Server Error', { status: 500 })
  }
}
