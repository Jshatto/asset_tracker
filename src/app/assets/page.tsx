'use client'

import { useAssets } from '@/lib/hooks/useAssets'

export default function AssetsPage() {
  const { data, isLoading, error } = useAssets()

  if (isLoading) {
    return <p>Loading…</p>
  }
  if (error) {
    return <p>Error: {error.message}</p>
  }

  return (
    <div className="overflow-x-auto">
      <table className="min-w-full divide-y divide-gray-200 text-sm">
        <caption className="sr-only">Assets</caption>
        <thead>
          <tr>
            <th className="px-4 py-2 text-left">ID</th>
            <th className="px-4 py-2 text-left">Name</th>
            <th className="px-4 py-2 text-left">Purchase Date</th>
            <th className="px-4 py-2 text-left">Purchase Price</th>
          </tr>
        </thead>
        <tbody>
          {data?.map(asset => (
            <tr key={asset.id} className="border-t">
              <td className="px-4 py-2">{asset.id}</td>
              <td className="px-4 py-2">{asset.asset_name}</td>
              <td className="px-4 py-2">
                {new Date(asset.purchase_date).toLocaleDateString()}
              </td>
              <td className="px-4 py-2">{asset.purchase_price}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}
