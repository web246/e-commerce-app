import { useProducts } from '@vendi/shared';
import { ProductCard } from '@/components/ProductCard';

export default function HomePage() {
  const { data: products = [], isLoading } = useProducts({ limit: 20 });

  return (
    <div>
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-vendi-text-primary">Vendi</h1>
        <p className="text-vendi-text-secondary mt-2">Discover products from trusted sellers</p>
      </div>

      {isLoading ? (
        <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-4">
          {Array.from({ length: 8 }).map((_, i) => (
            <div key={i} className="rounded-lg border border-vendi-border bg-white overflow-hidden animate-pulse">
              <div className="aspect-square bg-vendi-surface-hover" />
              <div className="p-4 space-y-2">
                <div className="h-4 bg-vendi-surface-hover rounded w-3/4" />
                <div className="h-3 bg-vendi-surface-hover rounded w-1/2" />
                <div className="h-5 bg-vendi-surface-hover rounded w-1/3" />
              </div>
            </div>
          ))}
        </div>
      ) : products.length === 0 ? (
        <div className="text-center py-20">
          <p className="text-vendi-text-tertiary">No products yet</p>
        </div>
      ) : (
        <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-4">
          {products.map((product) => (
            <ProductCard key={product.id} product={product} />
          ))}
        </div>
      )}
    </div>
  );
}
