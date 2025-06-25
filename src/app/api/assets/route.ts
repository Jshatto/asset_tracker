// src/app/api/assets/route.ts
import { importAssets } from '@/lib/services/importAssets'
import type { AssetImport } from 'src/types/asset'

export async function POST(req: Request) {
  let body: unknown
  try {
    body = await req.json()
  } catch {
    return new Response('Invalid JSON', { status: 400 })
  }

  if (!Array.isArray(body)) {
    return new Response('Expected an array of assets', { status: 400 })
  }
  const assets = body as AssetImport[]

  try {
    const result = await importAssets(assets)
    return new Response(JSON.stringify(result), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    })
  } catch (err: any) {
    console.error('❌ importAssets error:', err)
    // return the error message so we can see it
    return new Response(
      JSON.stringify({ error: err.message, stack: err.stack }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    )
  }
}
