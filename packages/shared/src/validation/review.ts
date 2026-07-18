import { z } from 'zod';

export const reviewSchema = z.object({
  productId: z.string().min(1),
  rating: z.number().int().min(1, 'Rating must be at least 1').max(5, 'Rating cannot exceed 5'),
  comment: z.string().min(10, 'Review must be at least 10 characters').max(2000),
  userName: z.string().min(1),
});

export type ReviewInput = z.infer<typeof reviewSchema>;
