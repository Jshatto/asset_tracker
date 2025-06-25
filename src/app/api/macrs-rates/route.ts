// src/app/api/macrs-rates/route.ts
import { importMacrsRates } from '@/lib/services/importMacrsRates'
import type { MacrsRateImport } from '../../../types/macrsRate'

export async function POST(req: Request) {
  let body: unknown
  try {
    body = await req.json()
  } catch {
    return new Response('Invalid JSON', { status: 400 })
  }
  if (!Array.isArray(body)) {
    return new Response('Expected an array of MACRS rates', { status: 400 })
  }
  const rates = body as MacrsRateImport[]

  try {
    const result = await importMacrsRates(rates)
    return new Response(JSON.stringify(result), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    })
  } catch (err: any) {
    console.error('❌ importMacrsRates error:', err)
    return new Response(
      JSON.stringify({ error: err.message, stack: err.stack }),
      {
        status: 500,
        headers: { 'Content-Type': 'application/json' },
      }
    )
  }
}
