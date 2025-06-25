// src/app/api/clients/route.ts
import { readFileSync } from 'fs'
import path from 'path'
import { pool } from '@/lib/database'
import { importClients } from '@/lib/services/importClients'
import type { Client } from 'src/types/client'
import type { ClientImport } from 'src/types/clients'

export async function GET() {
  try {
    const sql = readFileSync(
      path.resolve('sql/getClientList.sql'),
      'utf-8'
    )
    const { rows } = await pool.query<Client>(sql)
    return new Response(JSON.stringify(rows), {
      headers: { 'Content-Type': 'application/json' },
    })
  } catch (err: any) {
    console.error('getClientList error:', err)
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    })
  }
}

export async function POST(req: Request) {
  let body: unknown
  try {
    body = await req.json()
  } catch {
    return new Response('Invalid JSON', { status: 400 })
  }
  if (!Array.isArray(body)) {
    return new Response('Expected an array of clients', { status: 400 })
  }
  const clients = body as ClientImport[]
  try {
    const result = await importClients(clients)
    return new Response(JSON.stringify(result), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    })
  } catch (err: any) {
    console.error('❌ importClients error:', err)
    return new Response(err.message, { status: 500 })
  }
}
