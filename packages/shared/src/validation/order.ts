import { z } from 'zod';

export const addressSchema = z.object({
  fullName: z.string().min(1, 'Full name is required'),
  phone: z.string().min(10, 'Valid phone number required'),
  city: z.string().min(1, 'City is required'),
  area: z.string().min(1, 'Area is required'),
  county: z.string().min(1, 'County is required'),
});

export const orderItemSchema = z.object({
  productId: z.string().min(1),
  productName: z.string().min(1),
  productImage: z.string(),
  quantity: z.number().int().min(1, 'Quantity must be at least 1'),
  price: z.number().positive(),
  variant: z.string().optional(),
});

export const createOrderSchema = z.object({
  items: z.array(orderItemSchema).min(1, 'Order must have at least one item'),
  shippingAddress: addressSchema,
  paymentMethod: z.string().min(1, 'Payment method is required'),
  deliveryMethod: z.string().min(1, 'Delivery method is required'),
  couponCode: z.string().optional(),
  storeIds: z.array(z.string()).optional(),
});

export type CreateOrderInput = z.infer<typeof createOrderSchema>;
export type AddressInput = z.infer<typeof addressSchema>;
