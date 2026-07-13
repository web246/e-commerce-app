/**
 * Vendi seed script — populates Firestore with initial product catalog,
 * categories, and coupon codes.
 *
 * Usage:
 *   npx tsx scripts/seed.ts
 *
 * Requires: FIREBASE_TOKEN env var or already logged in via firebase CLI.
 * All data is dynamic — no hardcoded ratings or counts in the app.
 * Ratings are computed from the reviews collection at query time.
 */
import { initializeApp } from 'firebase/app';
import { getFirestore, collection, addDoc, doc, setDoc, serverTimestamp } from 'firebase/firestore';

const firebaseConfig = {
  apiKey: 'AIzaSyAC6-Y-VmeVZJujIoNgD3YHHFWOrLZcObg',
  authDomain: 'vendi-marketplace.firebaseapp.com',
  projectId: 'vendi-marketplace',
  storageBucket: 'vendi-marketplace.firebasestorage.app',
  messagingSenderId: '379407462565',
  appId: '1:379407462565:web:a7fbe2ff028ed0947cdd4c',
};

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

// ── Categories ───────────────────────────────────────────────────
const categories = [
  { name: 'Electronics', slug: 'electronics', icon: 'devices', sortOrder: 1, isActive: true },
  { name: 'Phones & Tablets', slug: 'phones', icon: 'smartphone', sortOrder: 2, isActive: true },
  { name: 'Fashion', slug: 'fashion', icon: 'checkroom', sortOrder: 3, isActive: true },
  { name: 'Computers', slug: 'computers', icon: 'computer', sortOrder: 4, isActive: true },
  { name: 'Home & Kitchen', slug: 'home-kitchen', icon: 'kitchen', sortOrder: 5, isActive: true },
  { name: 'Beauty', slug: 'beauty', icon: 'spa', sortOrder: 6, isActive: true },
  { name: 'Sports', slug: 'sports', icon: 'sports-soccer', sortOrder: 7, isActive: true },
  { name: 'Automotive', slug: 'automotive', icon: 'directions-car', sortOrder: 8, isActive: true },
];

// ── Products ──────────────────────────────────────────────────────
const products = [
  {
    name: 'iPhone 15 Pro',
    slug: 'iphone-15-pro',
    description: 'A17 Pro chip. Titanium design. 48MP camera system. The most powerful iPhone ever.',
    price: 145000,
    oldPrice: 165000,
    images: ['https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-15-pro-finish-select-202309-6-1inch-naturaltitanium?wid=5120&hei=2880&fmt=p-jpg'],
    category: 'phones',
    storeName: 'Apple Store Kenya',
    storeId: 'apple-store-ke',
    tags: ['new', 'premium', '5g'],
    sku: 'IP15P-256-NAT',
    stock: 50,
    isFeatured: true,
    isBestSeller: true,
    isFlashSale: false,
    specifications: { 'Display': '6.1" OLED', 'Chip': 'A17 Pro', 'Camera': '48MP + 12MP + 12MP', 'Battery': '3274 mAh', 'Storage': '256GB' },
    variants: [
      { name: 'Color', options: ['Natural Titanium', 'Blue Titanium', 'White Titanium', 'Black Titanium'] },
      { name: 'Storage', options: ['128GB', '256GB', '512GB', '1TB'] },
    ],
  },
  {
    name: 'Samsung Galaxy S24 Ultra',
    slug: 'samsung-galaxy-s24-ultra',
    description: 'Galaxy AI is here. 200MP camera. Built-in S Pen. The ultimate Galaxy experience.',
    price: 155000,
    oldPrice: 175000,
    images: ['https://images.samsung.com/is/image/samsung/p6pim/africa_en/2401/gallery/africa-en-galaxy-s24-s928-sm-s928bztqafc-539387384?$720_576_JPG$'],
    category: 'phones',
    storeName: 'Samsung Kenya',
    storeId: 'samsung-ke',
    tags: ['premium', '5g', 'ai'],
    sku: 'SGS24U-256-TIT',
    stock: 35,
    isFeatured: true,
    isBestSeller: true,
    isFlashSale: true,
    specifications: { 'Display': '6.8" Dynamic AMOLED', 'Chip': 'Snapdragon 8 Gen 3', 'Camera': '200MP + 50MP + 12MP + 10MP', 'Battery': '5000 mAh', 'Storage': '256GB' },
    variants: [{ name: 'Color', options: ['Titanium Gray', 'Titanium Black', 'Titanium Violet'] }],
  },
  {
    name: 'MacBook Pro 16" M3',
    slug: 'macbook-pro-16-m3',
    description: 'Supercharged by M3 Pro. 18-hour battery. Liquid Retina XDR display. Pro at every level.',
    price: 320000,
    images: ['https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/mbp16-spaceblack-select-202310?wid=4524&hei=3150&fmt=jpeg'],
    category: 'computers',
    storeName: 'Apple Store Kenya',
    storeId: 'apple-store-ke',
    tags: ['premium', 'laptop', 'professional'],
    sku: 'MBP16-M3P-512-SB',
    stock: 15,
    isFeatured: true,
    isBestSeller: false,
    isFlashSale: false,
    specifications: { 'Display': '16.2" Liquid Retina XDR', 'Chip': 'M3 Pro', 'RAM': '18GB', 'Storage': '512GB SSD', 'Battery': 'Up to 18 hours' },
    variants: [{ name: 'Color', options: ['Space Black', 'Silver'] }],
  },
  {
    name: 'Sony WH-1000XM5',
    slug: 'sony-wh-1000xm5',
    description: 'Industry-leading noise cancellation. 30-hour battery. Crystal clear hands-free calling.',
    price: 38000,
    oldPrice: 42000,
    images: ['https://www.sony.co.ke/image/5d02da5df552836db894cead8a68f5f3?fmt=png-alpha&wid=960'],
    category: 'electronics',
    storeName: 'Audio World KE',
    storeId: 'audio-world-ke',
    tags: ['audio', 'wireless', 'noise-cancelling'],
    sku: 'WH1000XM5-BLK',
    stock: 80,
    isFeatured: true,
    isBestSeller: true,
    isFlashSale: true,
    specifications: { 'Driver': '30mm', 'Battery': '30 hours', 'ANC': 'Yes', 'Weight': '250g', 'Connectivity': 'Bluetooth 5.2' },
    variants: [{ name: 'Color', options: ['Black', 'Silver', 'Midnight Blue'] }],
  },
  {
    name: 'Nike Air Max 90',
    slug: 'nike-air-max-90',
    description: 'Iconic silhouette. Visible Air cushioning. Waffle outsole. The classic, remastered.',
    price: 12500,
    oldPrice: 15000,
    images: ['https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/b1b5f2a8-6e7d-4fb4-b1c4-6e7b2d8c9f0a/air-max-90-shoes.png'],
    category: 'fashion',
    storeName: 'Nike Kenya',
    storeId: 'nike-ke',
    tags: ['shoes', 'sneakers', 'sportswear'],
    sku: 'NK-AM90-WHT-42',
    stock: 120,
    isFeatured: false,
    isBestSeller: true,
    isFlashSale: false,
    specifications: { 'Material': 'Leather + Textile', 'Sole': 'Rubber', 'Closure': 'Lace-up' },
    variants: [{ name: 'Size', options: ['UK 7', 'UK 8', 'UK 9', 'UK 10', 'UK 11'] }],
  },
  {
    name: 'PlayStation 5',
    slug: 'playstation-5',
    description: 'Play Like Never Before. Ultra-high speed SSD. 4K gaming. DualSense wireless controller.',
    price: 85000,
    oldPrice: 95000,
    images: ['https://gmedia.playstation.com/is/image/SIEPDC/ps5-product-thumbnail-01-en-16nov23?$facebook$'],
    category: 'electronics',
    storeName: 'Game Zone KE',
    storeId: 'gamezone-ke',
    tags: ['gaming', 'console', 'entertainment'],
    sku: 'PS5-DISC-1TB',
    stock: 25,
    isFeatured: true,
    isBestSeller: false,
    isFlashSale: true,
    specifications: { 'Storage': '825GB SSD', 'Resolution': 'Up to 4K 120fps', 'Controller': 'DualSense', 'HDR': 'Yes' },
    variants: [{ name: 'Edition', options: ['Disc Edition', 'Digital Edition'] }],
  },
  {
    name: 'Apple Watch Series 9',
    slug: 'apple-watch-series-9',
    description: 'S9 chip. Double tap gesture. Brighter display. Your essential companion for a healthy life.',
    price: 48000,
    oldPrice: 55000,
    images: ['https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/watch-card-40-s9-202309?wid=680&hei=528&fmt=png'],
    category: 'electronics',
    storeName: 'Apple Store Kenya',
    storeId: 'apple-store-ke',
    tags: ['wearable', 'fitness', 'health'],
    sku: 'AWS9-45-GPS-AL',
    stock: 60,
    isFeatured: false,
    isBestSeller: true,
    isFlashSale: false,
    specifications: { 'Display': '45mm Always-On Retina', 'Chip': 'S9 SiP', 'Battery': '18 hours', 'Water Resistance': 'WR50' },
    variants: [{ name: 'Size', options: ['41mm', '45mm'] }, { name: 'Color', options: ['Midnight', 'Starlight', 'Silver', 'Red'] }],
  },
  {
    name: 'JBL Flip 6',
    slug: 'jbl-flip-6',
    description: 'Bold JBL Original Pro Sound. IP67 waterproof. 12 hours of playtime. PartyBoost enabled.',
    price: 12000,
    oldPrice: 14500,
    images: ['https://www.jbl.co.ke/dw/image/v2/AAUJ_PRD/on/demandware.static/-/Sites-masterCatalog_Harman/default/dwf1b2c8e1/JBL_FLIP6_HERO_BLACK_48157_x2.png?sw=535&sh=535'],
    category: 'electronics',
    storeName: 'Audio World KE',
    storeId: 'audio-world-ke',
    tags: ['audio', 'bluetooth', 'portable'],
    sku: 'JBL-FLIP6-BLK',
    stock: 200,
    isFeatured: true,
    isBestSeller: false,
    isFlashSale: false,
    specifications: { 'Driver': '45mm', 'Battery': '12 hours', 'Waterproof': 'IP67', 'Weight': '550g', 'Bluetooth': '5.1' },
    variants: [{ name: 'Color', options: ['Black', 'Blue', 'Red', 'Teal', 'Gray'] }],
  },
  {
    name: 'Logitech MX Keys',
    slug: 'logitech-mx-keys',
    description: 'Perfect stroke keys. Smart illumination. Flow cross-computer control. USB-C charging.',
    price: 14500,
    images: ['https://resource.logitech.com/w_692,c_lpad,ar_4:3,q_auto,f_auto,dpr_1.0/d_transparent.gif/content/dam/logitech/en/products/mx/mx-keys/gallery/mx-keys-graphite-gallery-us.png?v=1'],
    category: 'computers',
    storeName: 'Tech Accessories KE',
    storeId: 'tech-acc-ke',
    tags: ['keyboard', 'productivity', 'wireless'],
    sku: 'LOG-MXKEYS-GR',
    stock: 90,
    isFeatured: false,
    isBestSeller: false,
    isFlashSale: false,
    specifications: { 'Layout': 'Full size', 'Connectivity': 'Bluetooth + USB receiver', 'Battery': 'Up to 10 days', 'Backlight': 'Smart illumination' },
    variants: [{ name: 'Layout', options: ['US English', 'UK English'] }],
  },
  {
    name: 'Anker PowerCore 20000',
    slug: 'anker-powercore-20000',
    description: '20,000mAh portable charger. PowerIQ 3.0 fast charging. Charge 3 devices at once.',
    price: 5500,
    oldPrice: 7000,
    images: ['https://www.anker.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/a/1/a1278_1.jpg'],
    category: 'electronics',
    storeName: 'Tech Accessories KE',
    storeId: 'tech-acc-ke',
    tags: ['power', 'portable', 'essential'],
    sku: 'ANK-PC20K-BLK',
    stock: 300,
    isFeatured: false,
    isBestSeller: true,
    isFlashSale: true,
    specifications: { 'Capacity': '20000mAh', 'Ports': '2x USB-A + 1x USB-C', 'Fast Charge': 'PowerIQ 3.0', 'Weight': '345g' },
    variants: [{ name: 'Color', options: ['Black', 'White'] }],
  },
];

// ── Coupons ──────────────────────────────────────────────────────
const coupons = [
  { code: 'WELCOME10', type: 'percent', value: 10, description: '10% off your first order', minOrderAmount: 1000, maxUses: 500, currentUses: 0, expiresAt: new Date('2027-07-13'), isActive: true },
  { code: 'SAVE20', type: 'percent', value: 20, description: '20% off electronics', minOrderAmount: 5000, maxUses: 200, currentUses: 0, expiresAt: new Date('2027-01-13'), isActive: true },
  { code: 'FREESHIP', type: 'free_shipping', value: 0, description: 'Free shipping on any order', minOrderAmount: 3000, maxUses: 1000, currentUses: 0, expiresAt: new Date('2027-07-13'), isActive: true },
  { code: 'FLAT500', type: 'fixed', value: 500, description: 'KSh 500 off orders above KSh 5000', minOrderAmount: 5000, maxUses: 300, currentUses: 0, expiresAt: new Date('2027-06-13'), isActive: true },
];

// ── Run ─────────────────────────────────────────────────────────
async function seed() {
  console.log('Seeding Vendi Marketplace...\n');

  // Categories
  console.log(`Creating ${categories.length} categories...`);
  for (const cat of categories) {
    await setDoc(doc(db, 'categories', cat.slug), cat);
  }
  console.log('  Done.\n');

  // Products
  console.log(`Creating ${products.length} products...`);
  for (const prod of products) {
    const { name, slug, description, price, oldPrice, images, category, storeName, storeId, tags, sku, stock, isFeatured, isBestSeller, isFlashSale, specifications, variants } = prod;
    await setDoc(doc(db, 'products', slug), {
      name, slug, description, price, oldPrice: oldPrice ?? null,
      images, category, storeName, storeId,
      tags, sku, stock,
      isFeatured, isBestSeller, isFlashSale,
      specifications: specifications ?? {},
      variants: variants ?? [],
      rating: 0, reviewCount: 0,
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp(),
    });
  }
  console.log('  Done.\n');

  // Coupons
  console.log(`Creating ${coupons.length} coupons...`);
  for (const coupon of coupons) {
    await setDoc(doc(db, 'coupons', coupon.code), coupon);
  }
  console.log('  Done.\n');

  console.log('Seed complete!');
  console.log(`  ${categories.length} categories`);
  console.log(`  ${products.length} products`);
  console.log(`  ${coupons.length} coupons`);
}

seed().catch(console.error).finally(() => process.exit(0));
