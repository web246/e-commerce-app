'use client';

import { useQuery, useQueryClient } from '@tanstack/react-query';
import { getProducts, getProductById, onProductsSnapshot } from '../firebase/firestore';
import type { Product } from '../types/models';
import { useEffect } from 'react';

export function useProducts(opts?: {
  category?: string;
  storeId?: string;
  featured?: boolean;
  bestSeller?: boolean;
  flashSale?: boolean;
  search?: string;
  limit?: number;
}) {
  return useQuery({
    queryKey: ['products', opts],
    queryFn: () => getProducts(opts),
    staleTime: 30_000,
  });
}

export function useProduct(id: string | undefined) {
  return useQuery({
    queryKey: ['product', id],
    queryFn: () => (id ? getProductById(id) : null),
    enabled: !!id,
    staleTime: 60_000,
  });
}

export function useLiveProducts(opts?: {
  category?: string;
  limit?: number;
}) {
  const queryClient = useQueryClient();

  useEffect(() => {
    const unsubscribe = onProductsSnapshot(
      (products: Product[]) => {
        queryClient.setQueryData(['products', opts], products);
      },
      opts
    );
    return () => unsubscribe();
  }, [opts?.category, opts?.limit, queryClient]);

  return useQuery({
    queryKey: ['products', opts],
    queryFn: () => getProducts(opts),
    staleTime: Infinity,
  });
}
