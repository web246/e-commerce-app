import { z } from 'zod';

export const productSchema = z.object({
  name: z.string().min(1, 'Product name is required').max(200),
  slug: z.string().min(1).max(200).regex(/^[a-z0-9-]+$/, 'Slug must be lowercase alphanumeric with hyphens'),
  description: z.string().max(5000).optional(),
  price: z.number().positive('Price must be positive'),
  oldPrice: z.number().positive().optional(),
  images: z.array(z.string().url()).min(1, 'At least one image required').max(20),
  category: z.string().optional(),
  storeId: z.string().optional(),
  stock: z.number().int().min(0, 'Stock cannot be negative'),
  isFeatured: z.boolean().default(false),
  isBestSeller: z.boolean().default(false),
  isFlashSale: z.boolean().default(false),
  tags: z.array(z.string()).default([]),
  sku: z.string().min(1, 'SKU is required'),
  specifications: z.record(z.string()).optional(),
  variants: z.array(z.object({
    name: z.string(),
    options: z.array(z.string()).min(1),
  })).optional(),
});

export type ProductInput = z.infer<typeof productSchema>;
