import React, { useRef, useEffect, useCallback } from 'react';
import { View, Text, FlatList, Animated, Dimensions, StyleSheet } from 'react-native';
import { useProducts, useCart } from '@vendi/shared';
import type { Product } from '@vendi/shared';
import { useColors, spacing, typography } from '../../../core/theme';
import { ScreenLayout } from '../../../core/ui/ScreenLayout';
import { ProductCard } from '../../../core/ui/ProductCard';
import { ProductSkeleton } from '../../../core/ui/Loading';
import { FadeInView, AnimatedEmptyState } from '../../../core/animations';
import { FloatingCart } from '../../../core/animations/FloatingCart';
import { useAppAuth } from '../../../core/context/AuthContext';

const { width } = Dimensions.get('window');
const HERO_IMAGE_SIZE = 120;

/** A single floating card in the hero — each drifts in a different pattern */
function HeroFloatCard({
  emoji,
  index,
  total,
}: {
  emoji: string;
  index: number;
  total: number;
}) {
  const floatY = useRef(new Animated.Value(0)).current;
  const floatX = useRef(new Animated.Value(0)).current;
  const rotate = useRef(new Animated.Value(0)).current;
  const scale = useRef(new Animated.Value(0.8)).current;

  useEffect(() => {
    const stagger = index * 500;
    const delay = (ms: number) => new Promise((r) => setTimeout(r, ms));

    (async () => {
      await delay(stagger);
      Animated.spring(scale, { toValue: 1, useNativeDriver: true, friction: 6, tension: 80 }).start();

      // Continuous gentle drift: each card has a unique cycle
      Animated.loop(
        Animated.sequence([
          Animated.timing(floatY, { toValue: -16 - index * 4, duration: 3000 + index * 800, useNativeDriver: true }),
          Animated.timing(floatY, { toValue: 0, duration: 3000 + index * 800, useNativeDriver: true }),
        ]),
      ).start();

      Animated.loop(
        Animated.sequence([
          Animated.timing(floatX, { toValue: 6 + index * 3, duration: 4000 + index * 600, useNativeDriver: true }),
          Animated.timing(floatX, { toValue: -6 - index * 3, duration: 4000 + index * 600, useNativeDriver: true }),
        ]),
      ).start();

      Animated.loop(
        Animated.sequence([
          Animated.timing(rotate, { toValue: 1, duration: 6000 + index * 1000, useNativeDriver: true }),
          Animated.timing(rotate, { toValue: -1, duration: 6000 + index * 1000, useNativeDriver: true }),
        ]),
      ).start();
    })();
  }, [floatY, floatX, rotate, scale, index]);

  const rotateDeg = rotate.interpolate({
    inputRange: [-1, 1],
    outputRange: ['-6deg', '6deg'],
  });

  const angle = ((index / total) * Math.PI * 2);
  const radius = 80;
  const cx = width / 2 - HERO_IMAGE_SIZE / 2;
  const cy = 80;

  return (
    <Animated.View
      style={[
        styles.heroCard,
        {
          left: cx + Math.cos(angle) * radius,
          top: cy + Math.sin(angle) * radius,
          transform: [{ translateX: floatX }, { translateY: floatY }, { rotate: rotateDeg }, { scale }],
        },
      ]}
    >
      <Text style={styles.heroEmoji}>{emoji}</Text>
    </Animated.View>
  );
}

export default function HomeScreen({ navigation }: any) {
  const colors = useColors();
  const { user } = useAppAuth();
  const { data: products = [], isLoading, refetch } = useProducts({ limit: 20 });
  const { data: cartItems = [] } = useCart(user?.id);

  const scrollY = useRef(new Animated.Value(0)).current;
  const headerOpacity = useRef(new Animated.Value(0)).current;
  const headerTranslate = useRef(new Animated.Value(-20)).current;
  const heroOpacity = useRef(new Animated.Value(0)).current;
  const heroScale = useRef(new Animated.Value(0.6)).current;

  useEffect(() => {
    Animated.parallel([
      Animated.timing(headerOpacity, { toValue: 1, duration: 400, useNativeDriver: true }),
      Animated.timing(headerTranslate, { toValue: 0, duration: 400, useNativeDriver: true }),
      Animated.timing(heroOpacity, { toValue: 1, duration: 800, delay: 300, useNativeDriver: true }),
      Animated.spring(heroScale, { toValue: 1, friction: 5, tension: 40, delay: 200, useNativeDriver: true }),
    ]).start();
  }, [headerOpacity, headerTranslate, heroOpacity, heroScale]);

  const onScroll = Animated.event(
    [{ nativeEvent: { contentOffset: { y: scrollY } } }],
    { useNativeDriver: false },
  );

  const renderProduct = useCallback(
    ({ item }: { item: Product }) => (
      <ProductCard product={item} onPress={() => navigation.navigate('Product', { id: item.id })} />
    ),
    [navigation],
  );

  const heroEmojis = ['🛍️', '📦', '🎯', '✨', '💎', '🚀'];

  return (
    <ScreenLayout scroll={false}>
      <FlatList
        data={products}
        renderItem={({ item, index }) => (
          <FadeInView delay={index * 80} duration={350}>
            {renderProduct({ item, index })}
          </FadeInView>
        )}
        keyExtractor={(item) => item.id}
        numColumns={2}
        contentContainerStyle={styles.list}
        columnWrapperStyle={{ gap: spacing.md, marginBottom: spacing.md }}
        refreshing={isLoading}
        onRefresh={refetch}
        onScroll={onScroll}
        scrollEventThrottle={16}
        ListHeaderComponent={
          <View>
            {/* ── Cinematic Hero Section ── */}
            <Animated.View
              style={[
                styles.heroSection,
                { opacity: heroOpacity, transform: [{ scale: heroScale }] },
              ]}
            >
              <View style={styles.heroCanvas}>
                {heroEmojis.map((emoji, idx) => (
                  <HeroFloatCard key={idx} emoji={emoji} index={idx} total={heroEmojis.length} />
                ))}
              </View>
              <View style={styles.heroText}>
                <Text style={[styles.heroTitle, { color: colors.textPrimary }]}>Vendi</Text>
                <Text style={[styles.heroSubtitle, { color: colors.textSecondary }]}>
                  Discover products you'll love
                </Text>
              </View>
            </Animated.View>

            {/* ── Section Header ── */}
            <Animated.View style={{ opacity: headerOpacity, transform: [{ translateY: headerTranslate }] }}>
              <View style={styles.header}>
                <Text style={[typography.titleMedium, { color: colors.textPrimary }]}>Featured Products</Text>
              </View>
            </Animated.View>
          </View>
        }
        ListEmptyComponent={
          isLoading ? (
            <View style={styles.skeletonRow}>
              <ProductSkeleton />
              <ProductSkeleton />
            </View>
          ) : (
            <FadeInView delay={200}>
              <AnimatedEmptyState icon="bag-outline" title="No products yet" subtitle="Check back later for new arrivals" />
            </FadeInView>
          )
        }
      />

      {/* ── Floating Cart FAB — always visible ── */}
      <FloatingCart
        itemCount={cartItems.length}
        onPress={() => navigation.navigate('Cart')}
      />
    </ScreenLayout>
  );
}

const styles = StyleSheet.create({
  heroSection: {
    paddingTop: spacing.md,
    paddingBottom: spacing.xl,
    alignItems: 'center',
  },
  heroCanvas: {
    width: width - spacing.cardPadding * 2,
    height: 200,
    position: 'relative',
    marginBottom: spacing.md,
  },
  heroCard: {
    position: 'absolute',
    width: 64,
    height: 64,
    borderRadius: 32,
    backgroundColor: '#FFFFFF',
    justifyContent: 'center',
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.1,
    shadowRadius: 12,
    elevation: 4,
  },
  heroEmoji: {
    fontSize: 30,
  },
  heroText: {
    alignItems: 'center',
    paddingHorizontal: spacing.cardPadding,
  },
  heroTitle: {
    fontSize: 34,
    fontWeight: '800',
    letterSpacing: -1,
  },
  heroSubtitle: {
    fontSize: 16,
    marginTop: spacing.xxs,
  },
  header: { paddingTop: spacing.md, paddingBottom: spacing.md },
  list: { paddingHorizontal: spacing.cardPadding, paddingBottom: 120 },
  skeletonRow: { flexDirection: 'row', gap: spacing.md },
});
