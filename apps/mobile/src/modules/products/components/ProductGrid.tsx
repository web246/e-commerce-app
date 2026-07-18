import React from 'react';
import { View, FlatList, Dimensions, StyleSheet } from 'react-native';
import { ProductCard, ProductSkeleton } from '../../../core/ui';
import { spacing, screenPadding } from '../../../core/theme';
import type { Product } from '@vendi/shared';

const { width } = Dimensions.get('window');
export const CARD_WIDTH = (width - screenPadding * 2 - spacing.md) / 2;

interface ProductGridProps {
  data: Product[];
  isLoading?: boolean;
  onRefresh?: () => void;
  refreshing?: boolean;
  onProductPress: (product: Product) => void;
  listHeaderComponent?: React.ReactElement;
}

export function ProductGrid({ data, isLoading, onRefresh, refreshing, onProductPress, listHeaderComponent }: ProductGridProps) {
  if (isLoading && data.length === 0) {
    return (
      <View style={styles.skeletonRow}>
        <View style={{ width: CARD_WIDTH }}><ProductSkeleton /></View>
        <View style={{ width: CARD_WIDTH }}><ProductSkeleton /></View>
      </View>
    );
  }

  return (
    <FlatList
      data={data}
      renderItem={({ item }) => (
        <View style={{ width: CARD_WIDTH }}>
          <ProductCard product={item} onPress={() => onProductPress(item)} />
        </View>
      )}
      keyExtractor={(item) => item.id}
      numColumns={2}
      contentContainerStyle={styles.list}
      columnWrapperStyle={{ gap: spacing.md, marginBottom: spacing.md }}
      refreshing={refreshing}
      onRefresh={onRefresh}
      ListHeaderComponent={listHeaderComponent}
    />
  );
}

const styles = StyleSheet.create({
  list: { paddingHorizontal: screenPadding, paddingBottom: 100 },
  skeletonRow: { flexDirection: 'row', gap: spacing.md, paddingHorizontal: screenPadding },
});
