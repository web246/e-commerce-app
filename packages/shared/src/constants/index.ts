export const PRODUCTS_PAGE_SIZE = 20;
export const REVIEWS_PAGE_SIZE = 10;
export const MAX_CART_ITEMS = 50;
export const MIN_PASSWORD_LENGTH = 8;
export const ORDER_NUMBER_PREFIX = 'ORD-';

export const DEFAULT_CATEGORIES = [
  'Electronics',
  'Phones & Tablets',
  'Fashion',
  'Computers',
  'Home & Kitchen',
  'Beauty',
  'Sports',
  'Automotive',
] as const;

export const PAYMENT_METHODS = [
  'M-Pesa',
  'Credit Card',
  'Bank Transfer',
  'Cash on Delivery',
] as const;

export const DELIVERY_METHODS = [
  'Standard Delivery',
  'Express Delivery',
  'Same Day Delivery',
  'Pickup Station',
] as const;
