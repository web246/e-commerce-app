'use client';

import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { getCart, saveCart } from '../firebase/firestore';
import type { CartItem } from '../types/models';

export function useCart(userId: string | undefined) {
  return useQuery({
    queryKey: ['cart', userId],
    queryFn: () => (userId ? getCart(userId) : []),
    enabled: !!userId,
    staleTime: 10_000,
  });
}

export function useUpdateCart() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async ({
      userId,
      items,
    }: {
      userId: string;
      items: CartItem[];
    }) => {
      await saveCart(userId, items);
    },
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['cart', variables.userId] });
    },
  });
}
