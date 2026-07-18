import { Link } from 'react-router-dom';
import type { Product } from '@vendi/shared';

interface ProductCardProps {
  product: Product;
}

export function ProductCard({ product }: ProductCardProps) {
  const hasDiscount = product.oldPrice != null && product.oldPrice > product.price;
  const discount = hasDiscount
    ? Math.round(((product.oldPrice! - product.price) / product.oldPrice!) * 100)
    : 0;

  return (
    <Link
      to={`/product/${product.id}`}
      className="group block rounded-lg border border-vendi-border bg-white overflow-hidden transition-shadow hover:shadow-md"
    >
      <div className="aspect-square bg-vendi-surface-hover overflow-hidden">
        <img
          src={product.images?.[0] ?? 'https://placehold.co/400x400/F1F5F9/94A3B8?text=No+Image'}
          alt={product.name}
          className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
        />
      </div>
      <div className="p-4">
        <h3 className="text-sm font-medium text-vendi-text-primary line-clamp-2 leading-tight">
          {product.name}
        </h3>
        {product.storeName && (
          <p className="text-xs text-vendi-text-tertiary mt-1 truncate">{product.storeName}</p>
        )}
        <div className="flex items-baseline gap-2 mt-2">
          <span className="text-base font-bold text-vendi-text-primary">
            KSh {product.price.toLocaleString()}
          </span>
          {hasDiscount && (
            <span className="text-xs text-vendi-text-tertiary line-through">
              KSh {product.oldPrice!.toLocaleString()}
            </span>
          )}
        </div>
        {hasDiscount && (
          <span className="inline-block mt-1 text-[10px] font-semibold text-white bg-vendi-error px-1.5 py-0.5 rounded">
            -{discount}%
          </span>
        )}
        {product.rating > 0 && (
          <p className="text-xs text-vendi-text-secondary mt-1">
            {'★'.repeat(Math.round(product.rating))} {product.rating} ({product.reviewCount})
          </p>
        )}
      </div>
    </Link>
  );
}
