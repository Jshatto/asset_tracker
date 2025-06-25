import { useQuery } from '@tanstack/react-query'
import type { Client } from 'src/types/client'

export function useClients() {
  return useQuery<Client[]>({
    queryKey: ['clients'],
    queryFn: async () => {
      const res = await fetch('/api/clients')
      if (!res.ok) {
        throw new Error('Failed to fetch clients')
      }
      return res.json() as Promise<Client[]>
    },
  })
}
