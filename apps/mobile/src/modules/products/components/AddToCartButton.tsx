import React from 'react';
import { Alert } from 'react-native';
import { Button } from '../../../core/ui/Button';
import { useCart, useUpdateCart } from '@vendi/shared';
import type { CartItem, Product } from '@vendi/shared';

interface AddToCartButtonProps {
  product: Product;
  userId?: string;
  cartItems: CartItem[];
}

export function AddToCartButton({ product, userId, cartItems }: AddToCartButtonProps) {
  const updateCart = useUpdateCart();

  const handleAddToCart = async () => {
    if (!userId) {
      Alert.alert('Sign In Required', 'Please sign in to add items to your cart.');
      return;
    }

    const existing = cartItems.findIndex((i: CartItem) => i.productId === product.id);
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
    await updateCart.mutateAsync({ userId, items: updated });
    Alert.alert('Added to Cart', `${product.name} has been added to your cart.`);
  };

  return (
    <Button variant="primary" size="lg" fullWidth icon="cart-outline" onPress={handleAddToCart}>
      Add to Cart — KSh {product.price.toLocaleString()}
    </Button>
  );
}
