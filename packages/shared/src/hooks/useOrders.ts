'use client';

import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { getUserOrders, createOrder } from '../firebase/firestore';
import { createOrderSchema, type CreateOrderInput } from '../validation/order';

export function useOrders(userId: string | undefined) {
  return useQuery({
    queryKey: ['orders', userId],
    queryFn: () => (userId ? getUserOrders(userId) : []),
    enabled: !!userId,
    staleTime: 30_000,
  });
}

export function useCreateOrder() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (input: CreateOrderInput & {
      buyerId: string;
      buyerName: string;
      subtotal: number;
      shippingFee: number;
      discount: number;
      total: number;
    }) => {
      const parsed = createOrderSchema.parse(input);
      return createOrder({
        ...parsed,
        buyerId: input.buyerId,
        buyerName: input.buyerName,
        subtotal: input.subtotal,
        shippingFee: input.shippingFee,
        discount: input.discount,
        total: input.total,
      });
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['orders'] });
    },
  });
}
