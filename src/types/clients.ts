import { string } from "zod/dist/types/v4"

// src/types/client.ts
export interface ClientImport {
  client_name: string   // or whatever your column is
  email?: string
  phone: string
  address: string
  entity_type: string
  tax_id: string
  return_type: string
  last_filing_date: string
  // …add any other fields you’ll import
  [key: string]: any
}
