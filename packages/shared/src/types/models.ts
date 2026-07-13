export interface User {
  id: string;
  name: string;
  email: string;
  phone?: string;
  role: 'customer' | 'seller' | 'admin';
  isVerified: boolean;
  avatarUrl?: string;
  createdAt?: string;
}

export interface Product {
  id: string;
  name: string;
  slug: string;
  description?: string;
  price: number;
  oldPrice?: number;
  images: string[];
  category?: string;
  storeId?: string;
  storeName?: string;
  rating: number;
  reviewCount: number;
  stock: number;
  isFeatured: boolean;
  isBestSeller: boolean;
  isFlashSale: boolean;
  tags: string[];
  sku: string;
  specifications?: Record<string, string>;
  variants?: ProductVariant[];
}

export interface ProductVariant {
  name: string;
  options: string[];
}

export interface Order {
  id: string;
  orderNumber: string;
  buyerId: string;
  buyerName: string;
  items: OrderItem[];
  total: number;
  subtotal: number;
  shippingFee: number;
  discount: number;
  status: OrderStatus;
  paymentMethod: string;
  deliveryMethod: string;
  shippingAddress: Address;
  timeline: OrderEvent[];
  createdAt: string;
  estimatedDelivery?: string;
}

export type OrderStatus = 'pending' | 'confirmed' | 'processing' | 'shipped' | 'delivered' | 'cancelled';

export interface OrderItem {
  productId: string;
  productName: string;
  productImage: string;
  quantity: number;
  price: number;
  variant?: string;
}

export interface OrderEvent {
  status: string;
  timestamp: string;
  description: string;
}

export interface Address {
  fullName: string;
  phone: string;
  city: string;
  area: string;
  county: string;
}

export interface Category {
  id: string;
  name: string;
  slug: string;
  icon: string;
  sortOrder: number;
}

export interface Review {
  id: string;
  productId: string;
  userId: string;
  userName: string;
  rating: number;
  comment: string;
  createdAt: string;
}

export interface CartItem {
  productId: string;
  productName: string;
  productImage: string;
  price: number;
  quantity: number;
  variant?: string;
  storeId?: string;
  storeName?: string;
}

export interface Store {
  id: string;
  name: string;
  slug: string;
  description?: string;
  logoUrl?: string;
  ownerId: string;
  category?: string;
}

export interface Coupon {
  code: string;
  type: 'percent' | 'fixed' | 'free_shipping';
  value: number;
  description: string;
}
