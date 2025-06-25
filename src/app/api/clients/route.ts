import { NextResponse } from "next/server";
import { readFile } from "fs/promises";
import { join } from "path";
import { pool } from "@/lib/database";
import type { Client } from "@/types/client";

export const dynamic = "force-dynamic";

let cachedSql: string | null = null;

export async function GET() {
  try {
    if (!cachedSql) {
      const sqlPath = join(process.cwd(), "sql", "getClientList.sql");
      cachedSql = await readFile(sqlPath, "utf8");
    }
    const { rows } = await pool.query<Client>(cachedSql);
    return NextResponse.json(rows, {
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("Error fetching client list:", err);
    return new NextResponse("Internal Server Error", { status: 500 });
  }
}
