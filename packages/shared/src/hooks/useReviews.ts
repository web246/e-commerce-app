'use client';

import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { getReviews, getAverageRating, addReview } from '../firebase/firestore';
import type { Review } from '../types/models';

export function useReviews(productId: string | undefined) {
  return useQuery({
    queryKey: ['reviews', productId],
    queryFn: async () => {
      if (!productId) return { reviews: [] as Review[], average: 0, count: 0 };
      const [reviews, { average, count }] = await Promise.all([
        getReviews(productId),
        getAverageRating(productId),
      ]);
      return { reviews, average, count };
    },
    enabled: !!productId,
    staleTime: 30_000,
  });
}

export function useSubmitReview() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (data: {
      productId: string;
      userId: string;
      rating: number;
      comment: string;
      userName: string;
    }) => {
      return addReview(data);
    },
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['reviews', variables.productId] });
      queryClient.invalidateQueries({ queryKey: ['product', variables.productId] });
    },
  });
}
