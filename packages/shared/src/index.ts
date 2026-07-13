// Design tokens
export { colors, typography, spacing, radii, motion } from './design/tokens';

// Types
export type {
  User, Product, ProductVariant, Order, OrderItem, OrderEvent, OrderStatus,
  Address, Category, Review, CartItem, Store, Coupon,
} from './types/models';

// Firebase
export { initFirebase, getFirebase } from './firebase/config';
export {
  getProducts, getProductById, getCategories, getReviews, getAverageRating,
  addReview, getUserOrders, createOrder, getCart, saveCart, onCartSnapshot,
  getWishlist, toggleWishlist, getStore, validateCoupon, getUserProfile, createUserProfile,
} from './firebase/firestore';

// Hooks
export { useAuth } from './hooks/useAuth';
export { useProducts, useProduct, useLiveProducts } from './hooks/useProducts';
export { useReviews } from './hooks/useReviews';
