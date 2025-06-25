// src/lib/services/calculateBookDepreciation.ts
import { readFileSync } from 'fs'
import path from 'path'
import { pool } from '../database'
import type { BookRow } from 'src/types/depreciation'

const sql = readFileSync(
  path.resolve('sql/v_book_depreciation.sql'),
  'utf-8'
)

export async function calculateBookDepreciation(): Promise<BookRow[]> {
  const { rows } = await pool.query<BookRow>(sql)
  return rows
}
