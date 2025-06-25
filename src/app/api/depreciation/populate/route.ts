// src/app/api/depreciation/populate/route.ts
import { populateDepreciation } from '@/lib/services/populateDepreciation'

export async function POST() {
  try {
    const { inserted } = await populateDepreciation()
    return new Response(JSON.stringify({ inserted }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    })
  } catch (err: any) {
    console.error('populateDepreciation error:', err)
    return new Response(
      JSON.stringify({ error: err.message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    )
  }
}
