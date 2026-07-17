import React from 'react';
import { View, Text, Image, FlatList, RefreshControl, StyleSheet, Dimensions } from 'react-native';
import { useStore, useProducts } from '@vendi/shared';
import { ScreenLayout, ProductCard, Spinner } from '../../../core/ui';
import { useColors, spacing, radii, screenPadding } from '../../../core/theme';
import type { Product } from '@vendi/shared';

const { width } = Dimensions.get('window');
const CARD_WIDTH = (width - screenPadding * 2 - spacing.md) / 2;

export default function StoreScreen({ route, navigation }: any) {
  const { storeId } = route.params;
  const { data: store, isLoading: storeLoading } = useStore(storeId);
  const { data: products = [], isLoading: productsLoading, refetch } = useProducts({ storeId, limit: 50 });
  const colors = useColors();

  const loading = storeLoading || productsLoading;

  const renderProduct = ({ item }: { item: Product }) => (
    <View style={{ width: CARD_WIDTH }}>
      <ProductCard
        product={item}
        onPress={() => navigation.navigate('Product', { id: item.id })}
      />
    </View>
  );

  if (loading && !store) {
    return <Spinner fullScreen />;
  }

  const ListHeader = () => (
    <View style={[styles.storeHeader, { borderBottomColor: colors.border }]}>
      <View style={styles.storeInfo}>
        {store?.logoUrl && (
          <Image source={{ uri: store.logoUrl }} style={[styles.storeLogo, { backgroundColor: colors.surfaceHover }]} />
        )}
        <View style={styles.storeMeta}>
          <Text style={[styles.storeName, { color: colors.textPrimary }]}>{store?.name ?? 'Store'}</Text>
          {store?.description && (
            <Text style={[styles.storeDescription, { color: colors.textSecondary }]} numberOfLines={3}>
              {store.description}
            </Text>
          )}
          <Text style={[styles.productCount, { color: colors.textTertiary }]}>
            {products.length} product{products.length !== 1 ? 's' : ''}
          </Text>
        </View>
      </View>
    </View>
  );

  return (
    <ScreenLayout title={store?.name ?? 'Store'} showBack>
      <FlatList
        data={products}
        renderItem={renderProduct}
        keyExtractor={(item) => item.id}
        numColumns={2}
        ListHeaderComponent={ListHeader}
        contentContainerStyle={styles.list}
        columnWrapperStyle={styles.row}
        refreshControl={
          <RefreshControl refreshing={loading} onRefresh={refetch} tintColor={colors.accent} />
        }
        ListEmptyComponent={
          <View style={styles.empty}>
            <Text style={[styles.emptyText, { color: colors.textTertiary }]}>
              This store has no products yet
            </Text>
          </View>
        }
      />
    </ScreenLayout>
  );
}

const styles = StyleSheet.create({
  storeHeader: {
    paddingTop: spacing.md,
    paddingBottom: spacing.lg,
    borderBottomWidth: 1,
    marginBottom: spacing.lg,
  },
  storeInfo: { flexDirection: 'row', gap: spacing.md },
  storeLogo: { width: 64, height: 64, borderRadius: radii.md },
  storeMeta: { flex: 1, justifyContent: 'center' },
  storeName: { fontSize: 22, fontWeight: '700' },
  storeDescription: { fontSize: 14, marginTop: 4, lineHeight: 20 },
  productCount: { fontSize: 13, marginTop: spacing.sm },
  list: { paddingBottom: 100 },
  row: { gap: spacing.md, marginBottom: spacing.md },
  empty: { paddingTop: 60, alignItems: 'center' },
  emptyText: { fontSize: 15 },
});
