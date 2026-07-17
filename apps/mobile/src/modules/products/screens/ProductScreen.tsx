import React, { useCallback } from 'react';
import {
  View, Text, Image, ScrollView, TouchableOpacity, Alert, StyleSheet,
} from 'react-native';
import { useProduct, useReviews, useUpdateCart, useCart } from '@vendi/shared';
import type { CartItem, Review } from '@vendi/shared';
import { useColors, spacing, typography, radii } from '../../../core/theme';
import { ScreenLayout } from '../../../core/ui/ScreenLayout';
import { Button } from '../../../core/ui/Button';
import { PriceDisplay } from '../../../core/ui/PriceDisplay';
import { Rating } from '../../../core/ui/Rating';
import { Spinner } from '../../../core/ui/Loading';
import { useAppAuth } from '../../../core/context/AuthContext';

export default function ProductScreen({ route, navigation }: any) {
  const { id } = route.params;
  const colors = useColors();
  const { user } = useAppAuth();
  const { data: product, isLoading: productLoading } = useProduct(id);
  const { data: reviewsData } = useReviews(id);
  const { data: cartItems = [] } = useCart(user?.id);
  const updateCart = useUpdateCart();

  const reviews = reviewsData?.reviews ?? [];
  const average = reviewsData?.average ?? 0;
  const count = reviewsData?.count ?? 0;

  const handleAddToCart = useCallback(async () => {
    if (!user) {
      Alert.alert('Sign In Required', 'Please sign in to add items to your cart.');
      return;
    }
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
    Alert.alert('Added to Cart', `${product.name} has been added to your cart.`);
  }, [user, cartItems, product, id, updateCart]);

  if (productLoading || !product) {
    return <Spinner fullScreen />;
  }

  return (
    <ScreenLayout scroll showBack>
      <ScrollView>
        <Image
          source={{ uri: product.images?.[0] ?? 'https://placehold.co/800x800/F1F5F9/94A3B8?text=No+Image' }}
          style={[styles.image, { backgroundColor: colors.surfaceHover }]}
        />

        <View style={[styles.body, { paddingBottom: 40 }]}>
          <Text style={[typography.headlineMedium, { color: colors.textPrimary }]}>{product.name}</Text>

          {product.storeName && (
            <TouchableOpacity onPress={() => navigation.navigate('Store', { storeId: product.storeId })}>
              <Text style={[typography.bodyMedium, { color: colors.accent, marginTop: spacing.xxs }]}>
                by {product.storeName}
              </Text>
            </TouchableOpacity>
          )}

          <View style={{ marginTop: spacing.sm }}>
            <Rating rating={average} count={count} size="md" />
          </View>

          <View style={{ marginTop: spacing.lg }}>
            <PriceDisplay price={product.price} oldPrice={product.oldPrice} size="lg" />
          </View>

          {product.description && (
            <Text style={[typography.bodyMedium, { color: colors.textSecondary, marginTop: spacing.lg, lineHeight: 22 }]}>
              {product.description}
            </Text>
          )}

          {product.specifications && Object.keys(product.specifications).length > 0 && (
            <View style={{ marginTop: spacing.xl }}>
              <Text style={[typography.titleMedium, { color: colors.textPrimary, marginBottom: spacing.md }]}>Specifications</Text>
              {Object.entries(product.specifications).map(([key, val]) => (
                <View key={key} style={[styles.specRow, { borderBottomColor: colors.border }]}>
                  <Text style={[typography.bodySmall, { color: colors.textTertiary, flex: 1 }]}>{key}</Text>
                  <Text style={[typography.bodyMedium, { color: colors.textPrimary, flex: 1 }]}>{String(val)}</Text>
                </View>
              ))}
            </View>
          )}

          {reviews.length > 0 && (
            <View style={{ marginTop: spacing.xl }}>
              <Text style={[typography.titleMedium, { color: colors.textPrimary, marginBottom: spacing.md }]}>
                Reviews ({count})
              </Text>
              {reviews.slice(0, 5).map((r: Review) => (
                <View key={r.id} style={[styles.reviewCard, { backgroundColor: colors.surface, borderColor: colors.border }]}>
                  <View style={styles.reviewHeader}>
                    <Text style={[typography.labelLarge, { color: colors.textPrimary }]}>{r.userName}</Text>
                    <Text style={{ fontSize: 13, color: colors.star }}>{'★'.repeat(r.rating)}</Text>
                  </View>
                  <Text style={[typography.bodyMedium, { color: colors.textSecondary, marginTop: spacing.xxs }]}>{r.comment}</Text>
                </View>
              ))}
            </View>
          )}

          {/* BUG FIXED: Added onPress handler for Add to Cart */}
          <Button
            variant="primary"
            size="lg"
            fullWidth
            icon="cart-outline"
            onPress={handleAddToCart}
          >
            Add to Cart — KSh {product.price.toLocaleString()}
          </Button>
        </View>
      </ScrollView>
    </ScreenLayout>
  );
}

const styles = StyleSheet.create({
  image: { width: '100%', aspectRatio: 1 },
  body: { padding: spacing.cardPadding },
  specRow: { flexDirection: 'row', paddingVertical: spacing.sm, borderBottomWidth: 1 },
  reviewCard: { padding: spacing.md, borderRadius: radii.md, borderWidth: 1, marginBottom: spacing.md },
  reviewHeader: { flexDirection: 'row', justifyContent: 'space-between' },
});
