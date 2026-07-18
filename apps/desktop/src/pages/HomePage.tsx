import { useProducts } from '@vendi/shared';
import { ProductCard } from '@/components/ProductCard';

export default function HomePage() {
  const { data: products = [], isLoading } = useProducts({ limit: 20 });

  return (
    <div>
      <h1 className="text-3xl font-bold text-vendi-text-primary mb-2">Vendi</h1>
      <p className="text-vendi-text-secondary mb-8">Discover products from trusted sellers</p>
      {isLoading ? (
        <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-4">
          {Array.from({ length: 8 }).map((_, i) => (
            <div key={i} className="rounded-lg border border-vendi-border bg-white animate-pulse">
              <div className="aspect-square bg-vendi-surface-hover" />
              <div className="p-4 space-y-2"><div className="h-4 bg-vendi-surface-hover rounded w-3/4" /><div className="h-3 bg-vendi-surface-hover rounded w-1/2" /></div>
            </div>
          ))}
        </div>
      ) : (
        <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-4">
          {products.map(p => <ProductCard key={p.id} product={p} />)}
        </div>
      )}
    </div>
  );
}
