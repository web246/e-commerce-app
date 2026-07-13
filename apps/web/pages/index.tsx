import { useEffect, useState } from 'react';
import { getProducts, initFirebase, colors } from '@vendi/shared';
import type { Product } from '@vendi/shared';

export default function Home() {
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    initFirebase();
    getProducts({ limit: 20 }).then(setProducts).finally(() => setLoading(false));
  }, []);

  return (
    <div style={styles.container}>
      <header style={styles.header}>
        <h1 style={styles.title}>Vendi</h1>
        <p style={styles.subtitle}>Discover products from trusted sellers</p>
      </header>
      <div style={styles.grid}>
        {loading ? (
          <p>Loading...</p>
        ) : products.length === 0 ? (
          <p>No products yet. Add products in Firestore to see them here.</p>
        ) : (
          products.map((p) => (
            <a key={p.id} href={`/product/${p.id}`} style={styles.card}>
              <img src={p.images?.[0] ?? '/placeholder.png'} alt={p.name} style={styles.image} />
              <div style={styles.cardBody}>
                <h3 style={styles.name}>{p.name}</h3>
                <p style={styles.store}>{p.storeName}</p>
                <p style={styles.price}>KSh {p.price.toLocaleString()}</p>
                {p.rating > 0 && <p style={styles.rating}>{'★'.repeat(Math.round(p.rating))} {p.rating}</p>}
              </div>
            </a>
          ))
        )}
      </div>
    </div>
  );
}

const styles: Record<string, React.CSSProperties> = {
  container: { maxWidth: 1200, margin: '0 auto', padding: '40px 20px', fontFamily: 'Inter, system-ui, sans-serif' },
  header: { marginBottom: 40 },
  title: { fontSize: 28, fontWeight: 700, color: '#0F172A', margin: 0 },
  subtitle: { fontSize: 16, color: '#475569', marginTop: 8 },
  grid: { display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(280px, 1fr))', gap: 24 },
  card: { textDecoration: 'none', color: 'inherit', borderRadius: 14, overflow: 'hidden', border: '1px solid #F1F5F9', backgroundColor: '#F8FAFC' },
  image: { width: '100%', aspectRatio: '1', objectFit: 'cover', backgroundColor: '#F1F5F9' },
  cardBody: { padding: 16 },
  name: { fontSize: 14, fontWeight: 500, color: '#0F172A', margin: 0 },
  store: { fontSize: 12, color: '#94A3B8', marginTop: 4 },
  price: { fontSize: 16, fontWeight: 700, color: '#0F172A', marginTop: 8 },
  rating: { fontSize: 12, color: '#475569', marginTop: 4 },
};
