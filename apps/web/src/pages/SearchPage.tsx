import { useState, useCallback } from 'react';
import { useProducts } from '@vendi/shared';
import { ProductCard } from '@/components/ProductCard';
import { Input } from '@/components/ui/input';

export default function SearchPage() {
  const [query, setQuery] = useState('');
  const [debounced, setDebounced] = useState('');

  const onChangeText = useCallback((value: string) => {
    setQuery(value);
    const timer = setTimeout(() => setDebounced(value), 400);
    return () => clearTimeout(timer);
  }, []);

  const { data: products = [], isLoading } = useProducts(
    debounced.trim() ? { search: debounced.trim(), limit: 50 } : { limit: 50 },
  );

  return (
    <div>
      <h1 className="text-2xl font-bold text-vendi-text-primary mb-6">Search Products</h1>

      <Input
        placeholder="Search products..."
        value={query}
        onChange={(e) => onChangeText(e.target.value)}
        className="mb-6"
      />

      {isLoading ? (
        <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-4">
          {Array.from({ length: 4 }).map((_, i) => (
            <div key={i} className="rounded-lg border border-vendi-border bg-white overflow-hidden animate-pulse">
              <div className="aspect-square bg-vendi-surface-hover" />
              <div className="p-4 space-y-2">
                <div className="h-4 bg-vendi-surface-hover rounded w-3/4" />
                <div className="h-3 bg-vendi-surface-hover rounded w-1/2" />
              </div>
            </div>
          ))}
        </div>
      ) : products.length === 0 ? (
        <div className="text-center py-20">
          <p className="text-vendi-text-tertiary">
            {debounced.trim()
              ? 'No products found. Try a different search.'
              : 'Start typing to search products'}
          </p>
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
