export { initFirebase, getFirebase, auth, db, storage } from './config';

export {
  signInWithEmail,
  registerWithEmail,
  signOutUser,
  sendPasswordReset,
  signInWithGoogle,
  signInWithGoogleRedirect,
  getGoogleRedirectResult,
  onAuthChanged,
  getCurrentUser,
} from './auth';

export type { FirebaseUser } from './auth';

export {
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
} from './firestore';
