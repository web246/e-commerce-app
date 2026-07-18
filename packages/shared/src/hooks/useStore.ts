'use client';

import { useQuery } from '@tanstack/react-query';
import { getStore } from '../firebase/firestore';

export function useStore(storeId: string | undefined) {
  return useQuery({
    queryKey: ['store', storeId],
    queryFn: () => (storeId ? getStore(storeId) : null),
    enabled: !!storeId,
    staleTime: 60_000,
  });
}
