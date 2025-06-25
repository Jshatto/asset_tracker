'use client'

import { useClients } from '@/lib/hooks/useClients'

export default function ClientsPage() {
  const { data, isLoading, error } = useClients()

  if (isLoading) {
    return <p>Loading…</p>
  }
  if (error) {
    return <p>Error: {error.message}</p>
  }

  return (
    <div className="overflow-x-auto">
      <table className="min-w-full divide-y divide-gray-200">
        <thead>
          <tr>
            <th className="px-4 py-2 text-left">ID</th>
            <th className="px-4 py-2 text-left">Name</th>
          </tr>
        </thead>
        <tbody>
          {data?.map(client => (
            <tr key={client.id} className="border-t">
              <td className="px-4 py-2">{client.id}</td>
              <td className="px-4 py-2">{client.client_name}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}
