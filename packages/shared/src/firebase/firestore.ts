import {
  collection,
  doc,
  query,
  where,
  orderBy,
  limit,
  getDocs,
  getDoc,
  addDoc,
  updateDoc,
  deleteDoc,
  serverTimestamp,
  onSnapshot,
  DocumentSnapshot,
  QueryDocumentSnapshot,
} from 'firebase/firestore';
import { db } from './config';
import type { Product, Order, Category, Review, Store, User, CartItem, Coupon, Address, OrderItem, OrderStatus } from '../types/models';

// ── Helpers ──────────────────────────────────────────────────────────
function docToData<T>(doc: DocumentSnapshot): T | null {
  if (!doc.exists()) return null;
  return { id: doc.id, ...doc.data() } as unknown as T;
}

function docsToData<T>(docs: QueryDocumentSnapshot[]): T[] {
  return docs.map((d) => ({ id: d.id, ...d.data() }) as unknown as T);
}

// ── Products ─────────────────────────────────────────────────────────
export const productsCol = () => collection(db, 'products');

export async function getProducts(opts?: { category?: string; storeId?: string; featured?: boolean; bestSeller?: boolean; flashSale?: boolean; search?: string; limit?: number }) {
  const constraints: any[] = [orderBy('createdAt', 'desc')];
  if (opts?.category) constraints.unshift(where('category', '==', opts.category));
  if (opts?.storeId) constraints.unshift(where('storeId', '==', opts.storeId));
  if (opts?.featured) constraints.unshift(where('isFeatured', '==', true));
  if (opts?.bestSeller) constraints.unshift(where('isBestSeller', '==', true));
  if (opts?.flashSale) constraints.unshift(where('isFlashSale', '==', true));
  if (opts?.limit) constraints.push(limit(opts.limit));
  const q = query(productsCol(), ...constraints);
  const snap = await getDocs(q);
  let products = docsToData<Product>(snap.docs);
  if (opts?.search) {
    const s = opts.search.toLowerCase();
    products = products.filter((p) => p.name.toLowerCase().includes(s) || p.description?.toLowerCase().includes(s));
  }
  return products;
}

export async function getProductById(id: string): Promise<Product | null> {
  return docToData<Product>(await getDoc(doc(db, 'products', id)));
}

export function onProductsSnapshot(callback: (products: Product[]) => void, opts?: { category?: string; limit?: number }) {
  const constraints: any[] = [orderBy('createdAt', 'desc')];
  if (opts?.category) constraints.unshift(where('category', '==', opts.category));
  if (opts?.limit) constraints.push(limit(opts.limit));
  const q = query(productsCol(), ...constraints);
  return onSnapshot(q, (snap) => callback(docsToData<Product>(snap.docs)));
}

// ── Categories ──────────────────────────────────────────────────────
export const categoriesCol = () => collection(db, 'categories');

export async function getCategories(): Promise<Category[]> {
  const q = query(categoriesCol(), orderBy('sortOrder'));
  return docsToData<Category>((await getDocs(q)).docs);
}

// ── Reviews ─────────────────────────────────────────────────────────
export async function getReviews(productId: string): Promise<Review[]> {
  const q = query(collection(db, 'reviews'), where('productId', '==', productId), orderBy('createdAt', 'desc'));
  return docsToData<Review>((await getDocs(q)).docs);
}

export async function getAverageRating(productId: string): Promise<{ average: number; count: number }> {
  const reviews = await getReviews(productId);
  if (reviews.length === 0) return { average: 0, count: 0 };
  const sum = reviews.reduce((a, r) => a + r.rating, 0);
  return { average: Math.round((sum / reviews.length) * 10) / 10, count: reviews.length };
}

export async function addReview(data: Omit<Review, 'id' | 'createdAt'>): Promise<string> {
  const ref = await addDoc(collection(db, 'reviews'), { ...data, createdAt: serverTimestamp() });
  // Update product review count and average
  const { average, count } = await getAverageRating(data.productId);
  await updateDoc(doc(db, 'products', data.productId), { rating: average, reviewCount: count });
  return ref.id;
}

// ── Orders ───────────────────────────────────────────────────────────
export async function getUserOrders(userId: string): Promise<Order[]> {
  const q = query(collection(db, 'orders'), where('buyerId', '==', userId), orderBy('createdAt', 'desc'));
  return docsToData<Order>((await getDocs(q)).docs);
}

export async function createOrder(order: {
  buyerId: string;
  buyerName: string;
  items: OrderItem[];
  shippingAddress: Address;
  paymentMethod: string;
  deliveryMethod: string;
  subtotal: number;
  shippingFee: number;
  discount: number;
  total: number;
  couponCode?: string;
  storeIds?: string[];
}): Promise<string> {
  const orderNumber = `ORD-${Date.now().toString(36).toUpperCase()}-${Math.random().toString(36).substring(2, 6).toUpperCase()}`;
  const ref = await addDoc(collection(db, 'orders'), {
    ...order,
    orderNumber,
    status: 'confirmed' as OrderStatus,
    timeline: [{ status: 'confirmed', timestamp: new Date().toISOString(), description: 'Order placed' }],
    estimatedDelivery: null,
    createdAt: serverTimestamp(),
  });
  return ref.id;
}

// ── Cart (per-user document) ─────────────────────────────────────────
export async function getCart(userId: string): Promise<CartItem[]> {
  const docSnap = await getDoc(doc(db, 'carts', userId));
  if (!docSnap.exists()) return [];
  return (docSnap.data().items ?? []) as CartItem[];
}

export async function saveCart(userId: string, items: CartItem[]): Promise<void> {
  await updateDoc(doc(db, 'carts', userId), { items, updatedAt: serverTimestamp() });
}

export function onCartSnapshot(userId: string, callback: (items: CartItem[]) => void) {
  return onSnapshot(doc(db, 'carts', userId), (snap) => {
    callback(snap.exists() ? (snap.data().items ?? []) as CartItem[] : []);
  });
}

// ── Wishlist ─────────────────────────────────────────────────────────
export async function getWishlist(userId: string): Promise<string[]> {
  const snap = await getDoc(doc(db, 'wishlists', userId));
  return snap.exists() ? (snap.data().productIds ?? []) as string[] : [];
}

export async function toggleWishlist(userId: string, productId: string): Promise<boolean> {
  const current = await getWishlist(userId);
  const exists = current.includes(productId);
  const updated = exists ? current.filter((id) => id !== productId) : [...current, productId];
  await updateDoc(doc(db, 'wishlists', userId), { productIds: updated });
  return !exists;
}

// ── Stores ───────────────────────────────────────────────────────────
export async function getStore(storeId: string): Promise<Store | null> {
  return docToData<Store>(await getDoc(doc(db, 'stores', storeId)));
}

// ── Coupons ──────────────────────────────────────────────────────────
export async function validateCoupon(code: string): Promise<Coupon | null> {
  const q = query(collection(db, 'coupons'), where('code', '==', code.toUpperCase()), where('isActive', '==', true));
  const docs = (await getDocs(q)).docs;
  if (docs.length === 0) return null;
  const coupon = docToData<Coupon>(docs[0])!;
  if (coupon.expiresAt && new Date(coupon.expiresAt) < new Date()) return null;
  return coupon;
}

// ── Users ────────────────────────────────────────────────────────────
export async function getUserProfile(userId: string): Promise<User | null> {
  return docToData<User>(await getDoc(doc(db, 'users', userId)));
}

export async function createUserProfile(userId: string, data: Partial<User>): Promise<void> {
  await updateDoc(doc(db, 'users', userId), { ...data, createdAt: serverTimestamp() });
}
