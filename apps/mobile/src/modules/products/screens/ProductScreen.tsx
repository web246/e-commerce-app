import React, { useCallback, useRef, useEffect, useState } from 'react';
import {
  View, Text, Image, ScrollView, Animated, StyleSheet,
} from 'react-native';
import { SafeAreaView, useSafeAreaInsets } from 'react-native-safe-area-context';
import { useProduct, useReviews, useUpdateCart, useCart } from '@vendi/shared';
import type { CartItem, Review } from '@vendi/shared';
import { useColors, spacing, typography, radii } from '../../../core/theme';
import { Button } from '../../../core/ui/Button';
import { PriceDisplay } from '../../../core/ui/PriceDisplay';
import { Rating } from '../../../core/ui/Rating';
import { Spinner } from '../../../core/ui/Loading';
import { useAppAuth } from '../../../core/context/AuthContext';
import { useToast } from '../../../core/context/ToastContext';
import { FadeInView, ScaleInView, SlideInView, ParallaxHeader } from '../../../core/animations';

export default function ProductScreen({ route, navigation }: any) {
  const { id } = route.params;
  const colors = useColors();
  const { user } = useAppAuth();
  const { showToast } = useToast();
  const { data: product, isLoading: productLoading } = useProduct(id);
  const { data: reviewsData } = useReviews(id);
  const { data: cartItems = [] } = useCart(user?.id);
  const updateCart = useUpdateCart();

  const reviews = reviewsData?.reviews ?? [];
  const average = reviewsData?.average ?? 0;
  const count = reviewsData?.count ?? 0;

  const scrollY = useRef(new Animated.Value(0)).current;
  const cartButtonScale = useRef(new Animated.Value(1)).current;
  const [justAdded, setJustAdded] = useState(false);

  useEffect(() => {
    if (justAdded) {
      const timer = setTimeout(() => setJustAdded(false), 1500);
      return () => clearTimeout(timer);
    }
  }, [justAdded]);

  const onScroll = Animated.event(
    [{ nativeEvent: { contentOffset: { y: scrollY } } }],
    { useNativeDriver: false },
  );

  const handleAddToCart = useCallback(async () => {
    if (!user) {
      showToast('Please sign in to add items to your cart', 'error');
      return;
    }
    if (!product) return;

    // Press animation
    Animated.sequence([
      Animated.spring(cartButtonScale, { toValue: 0.95, useNativeDriver: true, friction: 8 }),
      Animated.spring(cartButtonScale, { toValue: 1, useNativeDriver: true, friction: 5 }),
    ]).start();

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
    setJustAdded(true);
    showToast('Added to cart!', 'success');
  }, [user, cartItems, product, id, updateCart, cartButtonScale, showToast]);

  const insets = useSafeAreaInsets();

  if (productLoading || !product) {
    return <Spinner fullScreen />;
  }

  const contentAreaTop = 250 + insets.top;

  return (
    <View style={styles.screen}>
      {/* ── Parallax Header (pushed below status bar) ── */}
      <ParallaxHeader topInset={insets.top}
        scrollY={scrollY}
        title={product.name}
        subtitle={`KSh ${product.price.toLocaleString()}`}
        background={
          <Image
            source={{ uri: product.images?.[0] ?? 'https://placehold.co/800x800/F1F5F9/94A3B8?text=No+Image' }}
            style={styles.parallaxImage}
          />
        }
      />

      {/* ── Scrollable Content ── */}
      <Animated.ScrollView
        onScroll={onScroll}
        scrollEventThrottle={16}
        contentContainerStyle={{ paddingTop: contentAreaTop, paddingBottom: 40 }}
        showsVerticalScrollIndicator={false}
      >
        <View style={styles.body}>
          {/* Store name */}
          {product.storeName && (
            <SlideInView delay={100} direction="up" distance={20}>
              <Text
                style={[typography.bodyMedium, { color: colors.accent, marginBottom: spacing.sm }]}
                onPress={() => navigation.navigate('Store', { storeId: product.storeId })}
              >
                by {product.storeName}
              </Text>
            </SlideInView>
          )}

          {/* Rating */}
          <SlideInView delay={150} direction="up" distance={20}>
            <View style={{ marginBottom: spacing.md }}>
              <Rating rating={average} count={count} size="md" />
            </View>
          </SlideInView>

          {/* Description */}
          {product.description && (
            <FadeInView delay={200}>
              <Text style={[typography.bodyMedium, { color: colors.textSecondary, lineHeight: 22, marginBottom: spacing.lg }]}>
                {product.description}
              </Text>
            </FadeInView>
          )}

          {/* Specifications */}
          {product.specifications && Object.keys(product.specifications).length > 0 && (
            <FadeInView delay={250}>
              <View style={{ marginBottom: spacing.xl }}>
                <Text style={[typography.titleMedium, { color: colors.textPrimary, marginBottom: spacing.md }]}>
                  Specifications
                </Text>
                {Object.entries(product.specifications).map(([key, val], i) => (
                  <SlideInView key={key} delay={300 + i * 50} direction="left" distance={20}>
                    <View style={[styles.specRow, { borderBottomColor: colors.border }]}>
                      <Text style={[typography.bodySmall, { color: colors.textTertiary, flex: 1 }]}>{key}</Text>
                      <Text style={[typography.bodyMedium, { color: colors.textPrimary, flex: 1 }]}>{String(val)}</Text>
                    </View>
                  </SlideInView>
                ))}
              </View>
            </FadeInView>
          )}

          {/* Reviews */}
          {reviews.length > 0 && (
            <FadeInView delay={400}>
              <View style={{ marginBottom: spacing.xl }}>
                <Text style={[typography.titleMedium, { color: colors.textPrimary, marginBottom: spacing.md }]}>
                  Reviews ({count})
                </Text>
                {reviews.slice(0, 5).map((r: Review, i: number) => (
                  <SlideInView key={r.id} delay={450 + i * 80} direction="left" distance={20}>
                    <View style={[styles.reviewCard, { backgroundColor: colors.surface, borderColor: colors.border }]}>
                      <View style={styles.reviewHeader}>
                        <Text style={[typography.labelLarge, { color: colors.textPrimary }]}>{r.userName}</Text>
                        <Text style={{ fontSize: 13, color: colors.star }}>{'★'.repeat(r.rating)}</Text>
                      </View>
                      <Text style={[typography.bodyMedium, { color: colors.textSecondary, marginTop: spacing.xxs }]}>
                        {r.comment}
                      </Text>
                    </View>
                  </SlideInView>
                ))}
              </View>
            </FadeInView>
          )}

          {/* Add to Cart button */}
          <FadeInView delay={500}>
            <Animated.View style={{ transform: [{ scale: cartButtonScale }] }}>
              <Button
                variant="primary"
                size="lg"
                fullWidth
                icon={justAdded ? 'checkmark-circle-outline' : 'cart-outline'}
                onPress={handleAddToCart}
              >
                {justAdded ? 'Added!' : `Add to Cart — KSh ${product.price.toLocaleString()}`}
              </Button>
            </Animated.View>
          </FadeInView>
        </View>
      </Animated.ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  screen: { flex: 1 },
  parallaxImage: { width: '100%', height: '100%', resizeMode: 'cover' },
  body: { padding: spacing.cardPadding },
  specRow: { flexDirection: 'row', paddingVertical: spacing.sm, borderBottomWidth: 1 },
  reviewCard: { padding: spacing.md, borderRadius: radii.md, borderWidth: 1, marginBottom: spacing.md },
  reviewHeader: { flexDirection: 'row', justifyContent: 'space-between' },
});
