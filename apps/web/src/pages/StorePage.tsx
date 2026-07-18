import { useParams } from 'react-router-dom';
import { useStore, useProducts } from '@vendi/shared';
import { ProductCard } from '@/components/ProductCard';

export default function StorePage() {
  const { storeId } = useParams<{ storeId: string }>();
  const { data: store, isLoading: storeLoading } = useStore(storeId);
  const { data: products = [], isLoading: productsLoading } = useProducts({
    storeId,
    limit: 50,
  });

  if (storeLoading || (!store && productsLoading)) {
    return <div className="py-20 text-center text-vendi-text-tertiary">Loading store...</div>;
  }

  return (
    <div>
      {/* Store header */}
      <div className="border-b border-vendi-border pb-6 mb-6">
        <div className="flex items-center gap-4">
          {store?.logoUrl && (
            <img
              src={store.logoUrl}
              alt={store?.name}
              className="w-16 h-16 rounded-lg object-cover bg-vendi-surface-hover"
            />
          )}
          <div>
            <h1 className="text-2xl font-bold text-vendi-text-primary">
              {store?.name ?? 'Store'}
            </h1>
            {store?.description && (
              <p className="text-vendi-text-secondary mt-1">{store.description}</p>
            )}
            <p className="text-sm text-vendi-text-tertiary mt-1">
              {products.length} product{products.length !== 1 ? 's' : ''}
            </p>
          </div>
        </div>
      </div>

      {productsLoading ? (
        <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-4">
          {Array.from({ length: 4 }).map((_, i) => (
            <div key={i} className="rounded-lg border border-vendi-border bg-white animate-pulse">
              <div className="aspect-square bg-vendi-surface-hover" />
              <div className="p-4 space-y-2">
                <div className="h-4 bg-vendi-surface-hover rounded w-3/4" />
                <div className="h-5 bg-vendi-surface-hover rounded w-1/3" />
              </div>
            </div>
          ))}
        </div>
      ) : products.length === 0 ? (
        <div className="py-20 text-center text-vendi-text-tertiary">
          This store has no products yet
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
