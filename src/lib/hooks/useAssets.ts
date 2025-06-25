import { useQuery } from '@tanstack/react-query'
import type { Asset } from 'src/types/asset'

export function useAssets() {
  return useQuery<Asset[]>({
    queryKey: ['assets'],
    queryFn: async () => {
      const res = await fetch('/api/assets')
      if (!res.ok) {
        throw new Error('Failed to fetch assets')
      }
      return res.json() as Promise<Asset[]>
    },
  })
}
