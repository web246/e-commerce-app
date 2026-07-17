import React from 'react';
import { View, Text, FlatList, StyleSheet } from 'react-native';
import { useProducts } from '@vendi/shared';
import type { Product } from '@vendi/shared';
import { useColors, spacing, typography } from '../../../core/theme';
import { ScreenLayout } from '../../../core/ui/ScreenLayout';
import { ProductCard } from '../../../core/ui/ProductCard';
import { ProductSkeleton } from '../../../core/ui/Loading';
import { EmptyState } from '../../../core/ui/EmptyState';

export default function HomeScreen({ navigation }: any) {
  const colors = useColors();
  const { data: products = [], isLoading, refetch } = useProducts({ limit: 20 });

  const renderProduct = ({ item }: { item: Product }) => (
    <ProductCard
      product={item}
      onPress={() => navigation.navigate('Product', { id: item.id })}
    />
  );

  return (
    <ScreenLayout scroll={false}>
      <FlatList
        data={products}
        renderItem={renderProduct}
        keyExtractor={(item) => item.id}
        numColumns={2}
        contentContainerStyle={styles.list}
        columnWrapperStyle={{ gap: spacing.md, marginBottom: spacing.md }}
        refreshing={isLoading}
        onRefresh={refetch}
        ListHeaderComponent={
          <View style={styles.header}>
            <Text style={[typography.displayMedium, { color: colors.textPrimary }]}>Vendi</Text>
            <Text style={[typography.bodyMedium, { color: colors.textSecondary, marginTop: spacing.xxs }]}>
              Discover products
            </Text>
          </View>
        }
        ListEmptyComponent={
          isLoading ? (
            <View style={styles.skeletonRow}>
              <ProductSkeleton />
              <ProductSkeleton />
            </View>
          ) : (
            <EmptyState icon="bag-outline" title="No products yet" subtitle="Check back later for new arrivals" />
          )
        }
      />
    </ScreenLayout>
  );
}

const styles = StyleSheet.create({
  header: { paddingTop: spacing.md, paddingBottom: spacing.lg },
  list: { paddingHorizontal: spacing.cardPadding, paddingBottom: 100 },
  skeletonRow: { flexDirection: 'row', gap: spacing.md },
});
