// ── Design Tokens ────────────────────────────────────────────────────────────
export { colors, typography, spacing, radii, motion } from './design/tokens';

// ── Types ────────────────────────────────────────────────────────────────────
export type {
  User, Product, ProductVariant, Order, OrderItem, OrderEvent,
  Address, Category, Review, CartItem, Store, Coupon,
} from './types/models';

export type { OrderStatus, UserRole, CouponType } from './types/enums';
export { ORDER_STATUS_LABELS, ORDER_STATUS_COLORS } from './types/enums';

// ── Validation ───────────────────────────────────────────────────────────────
export { productSchema, createOrderSchema, addressSchema, reviewSchema } from './validation';
export type { ProductInput, CreateOrderInput, AddressInput, ReviewInput } from './validation';

// ── Firebase ─────────────────────────────────────────────────────────────────
export {
  initFirebase,
  getFirebase,
  auth,
  db,
  storage,
  signInWithEmail,
  registerWithEmail,
  signOutUser,
  sendPasswordReset,
  signInWithGoogle,
  signInWithGoogleRedirect,
  getGoogleRedirectResult,
  onAuthChanged,
  getCurrentUser,
  getProducts,
  getProductById,
  onProductsSnapshot,
  getCategories,
  getReviews,
  getAverageRating,
  addReview,
  getUserOrders,
  createOrder,
  getCart,
  saveCart,
  onCartSnapshot,
  getWishlist,
  toggleWishlist,
  getStore,
  validateCoupon,
  getUserProfile,
  createUserProfile,
} from './firebase';

export type { FirebaseUser } from './firebase';

// ── Hooks ────────────────────────────────────────────────────────────────────
export {
  useAuth,
  useProducts,
  useProduct,
  useLiveProducts,
  useReviews,
  useSubmitReview,
  useOrders,
  useCreateOrder,
  useCart,
  useUpdateCart,
  useWishlist,
  useToggleWishlist,
  useStore,
} from './hooks';

// ── Constants ────────────────────────────────────────────────────────────────
export {
  PRODUCTS_PAGE_SIZE,
  REVIEWS_PAGE_SIZE,
  MAX_CART_ITEMS,
  MIN_PASSWORD_LENGTH,
  DEFAULT_CATEGORIES,
  PAYMENT_METHODS,
  DELIVERY_METHODS,
} from './constants';
