import { useCallback } from 'react';
import { useParams, Link } from 'react-router-dom';
import { useProduct, useReviews, useCart, useUpdateCart } from '@vendi/shared';
import { useAppAuth } from '@/context/AuthContext';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import type { CartItem } from '@vendi/shared';

export default function ProductPage() {
  const { id } = useParams<{ id: string }>();
  const { user } = useAppAuth();
  const { data: product, isLoading: loading } = useProduct(id);
  const { data: reviewsData } = useReviews(id);
  const { data: cartItems = [] as CartItem[] } = useCart(user?.id);
  const updateCart = useUpdateCart();

  const reviews = reviewsData?.reviews ?? [];
  const average = reviewsData?.average ?? 0;
  const count = reviewsData?.count ?? 0;

  const handleAddToCart = useCallback(async () => {
    if (!user) return alert('Please sign in to add items to your cart.');
    if (!product) return;
    const existing = cartItems.findIndex((i: CartItem) => i.productId === id);
    let updated: CartItem[];
    if (existing >= 0) {
      updated = cartItems.map((item: CartItem, i: number) =>
        i === existing ? { ...item, quantity: item.quantity + 1 } : item,
      );
    } else {
      updated = [
        ...cartItems,
        {
          productId: product.id,
          productName: product.name,
          productImage: product.images?.[0] ?? '',
          price: product.price,
          quantity: 1,
          storeId: product.storeId,
          storeName: product.storeName,
        },
      ];
    }
    await updateCart.mutateAsync({ userId: user.id, items: updated });
    alert(`${product.name} added to cart!`);
  }, [user, product, cartItems, id, updateCart]);

  if (loading || !product) {
    return (
      <div className="max-w-4xl mx-auto py-20 text-center text-vendi-text-tertiary">
        Loading...
      </div>
    );
  }

  const hasDiscount = product.oldPrice != null && product.oldPrice > product.price;
  const discount = hasDiscount
    ? Math.round(((product.oldPrice! - product.price) / product.oldPrice!) * 100)
    : 0;

  return (
    <div className="max-w-4xl mx-auto">
      <div className="grid md:grid-cols-2 gap-8">
        {/* Image */}
        <div className="aspect-square bg-vendi-surface-hover rounded-lg overflow-hidden">
          <img
            src={product.images?.[0] ?? 'https://placehold.co/800x800/F1F5F9/94A3B8?text=No+Image'}
            alt={product.name}
            className="w-full h-full object-cover"
          />
        </div>

        {/* Details */}
        <div>
          <h1 className="text-2xl font-bold text-vendi-text-primary">{product.name}</h1>

          {product.storeName && product.storeId && (
            <Link
              to={`/store/${product.storeId}`}
              className="text-sm text-vendi-accent hover:underline mt-1 inline-block"
            >
              by {product.storeName}
            </Link>
          )}

          {/* Rating */}
          <div className="flex items-center gap-2 mt-3">
            <span className="text-yellow-500">
              {'★'.repeat(Math.round(average))}{'☆'.repeat(5 - Math.round(average))}
            </span>
            <span className="text-sm text-vendi-text-secondary">
              {average > 0 ? `${average} (${count} reviews)` : 'No reviews yet'}
            </span>
          </div>

          {/* Price */}
          <div className="flex items-baseline gap-3 mt-6">
            <span className="text-3xl font-bold text-vendi-text-primary">
              KSh {product.price.toLocaleString()}
            </span>
            {hasDiscount && (
              <>
                <span className="text-lg text-vendi-text-tertiary line-through">
                  KSh {product.oldPrice!.toLocaleString()}
                </span>
                <Badge variant="destructive">-{discount}%</Badge>
              </>
            )}
          </div>

          {/* Description */}
          {product.description && (
            <p className="text-vendi-text-secondary mt-6 leading-relaxed">{product.description}</p>
          )}

          {/* Specifications */}
          {product.specifications && Object.keys(product.specifications).length > 0 && (
            <div className="mt-6">
              <h3 className="font-semibold text-vendi-text-primary mb-3">Specifications</h3>
              <div className="space-y-2">
                {Object.entries(product.specifications).map(([key, val]) => (
                  <div key={key} className="flex text-sm border-b border-vendi-border py-2">
                    <span className="text-vendi-text-tertiary w-1/3">{key}</span>
                    <span className="text-vendi-text-primary">{String(val)}</span>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* Add to Cart */}
          <Button size="lg" className="w-full mt-8" onClick={handleAddToCart}>
            Add to Cart — KSh {product.price.toLocaleString()}
          </Button>
        </div>
      </div>

      {/* Reviews */}
      {reviews.length > 0 && (
        <div className="mt-12">
          <h2 className="text-xl font-semibold text-vendi-text-primary mb-6">
            Reviews ({count})
          </h2>
          <div className="space-y-4">
            {reviews.slice(0, 5).map((r: any) => (
              <div
                key={r.id}
                className="border border-vendi-border rounded-lg p-4 bg-vendi-surface"
              >
                <div className="flex items-center justify-between">
                  <span className="font-medium text-vendi-text-primary text-sm">{r.userName}</span>
                  <span className="text-yellow-500">{'★'.repeat(r.rating)}</span>
                </div>
                <p className="text-sm text-vendi-text-secondary mt-2">{r.comment}</p>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
