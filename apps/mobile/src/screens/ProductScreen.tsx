import React from 'react';
import {
  View, Text, Image, ScrollView, TouchableOpacity, StyleSheet,
  Dimensions, ActivityIndicator,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useProduct, useReviews, colors, spacing, radii } from '@vendi/shared';

const { width } = Dimensions.get('window');

export default function ProductScreen({ route, navigation }: any) {
  const { id } = route.params;
  const { product, loading } = useProduct(id);
  const { reviews, average, count } = useReviews(id);

  if (loading || !product) {
    return (
      <SafeAreaView style={styles.container}>
        <ActivityIndicator size="large" color={colors.accent} style={{ marginTop: 100 }} />
      </SafeAreaView>
    );
  }

  const hasDiscount = product.oldPrice != null && product.oldPrice > product.price;
  const discount = hasDiscount ? Math.round(((product.oldPrice! - product.price) / product.oldPrice!) * 100) : 0;

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      <ScrollView>
        <Image source={{ uri: product.images?.[0] ?? 'https://placehold.co/800x800/F1F5F9/94A3B8?text=No+Image' }} style={styles.image} />
        <View style={styles.body}>
          <Text style={styles.name}>{product.name}</Text>
          {product.storeName && <Text style={styles.store}>by {product.storeName}</Text>}

          <View style={styles.ratingRow}>
            <Text style={styles.ratingStars}>{'★'.repeat(Math.round(average))}{'☆'.repeat(5 - Math.round(average))}</Text>
            <Text style={styles.ratingText}>{average > 0 ? `${average} (${count} reviews)` : 'No reviews yet'}</Text>
          </View>

          <View style={styles.priceRow}>
            <Text style={styles.price}>KSh {product.price.toLocaleString()}</Text>
            {hasDiscount && <Text style={styles.oldPrice}>KSh {product.oldPrice!.toLocaleString()}</Text>}
            {hasDiscount && <View style={styles.discountBadge}><Text style={styles.discountText}>-{discount}%</Text></View>}
          </View>

          {product.description && <Text style={styles.description}>{product.description}</Text>}

          {product.specifications && Object.keys(product.specifications).length > 0 && (
            <View style={styles.section}>
              <Text style={styles.sectionTitle}>Specifications</Text>
              {Object.entries(product.specifications).map(([key, val]) => (
                <View key={key} style={styles.specRow}>
                  <Text style={styles.specKey}>{key}</Text>
                  <Text style={styles.specVal}>{val}</Text>
                </View>
              ))}
            </View>
          )}

          {reviews.length > 0 && (
            <View style={styles.section}>
              <Text style={styles.sectionTitle}>Reviews ({count})</Text>
              {reviews.slice(0, 5).map((r) => (
                <View key={r.id} style={styles.reviewCard}>
                  <View style={styles.reviewHeader}>
                    <Text style={styles.reviewAuthor}>{r.userName}</Text>
                    <Text style={styles.reviewRating}>{'★'.repeat(r.rating)}</Text>
                  </View>
                  <Text style={styles.reviewComment}>{r.comment}</Text>
                </View>
              ))}
            </View>
          )}

          <TouchableOpacity style={styles.addButton} activeOpacity={0.8}>
            <Text style={styles.addButtonText}>Add to Cart — KSh {product.price.toLocaleString()}</Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.background },
  image: { width, height: width, backgroundColor: colors.surfaceHover },
  body: { padding: spacing.screenHorizontal },
  name: { fontSize: 22, fontWeight: '700', color: colors.textPrimary, marginTop: spacing.md },
  store: { fontSize: 14, color: colors.textSecondary, marginTop: 4 },
  ratingRow: { flexDirection: 'row', alignItems: 'center', marginTop: spacing.sm, gap: spacing.xs },
  ratingStars: { fontSize: 16, color: '#F59E0B' },
  ratingText: { fontSize: 13, color: colors.textSecondary },
  priceRow: { flexDirection: 'row', alignItems: 'baseline', gap: spacing.sm, marginTop: spacing.lg },
  price: { fontSize: 24, fontWeight: '700', color: colors.textPrimary },
  oldPrice: { fontSize: 16, color: colors.textTertiary, textDecorationLine: 'line-through' },
  discountBadge: { backgroundColor: colors.error, borderRadius: radii.sm, paddingHorizontal: spacing.sm, paddingVertical: 2 },
  discountText: { color: colors.textInverse, fontSize: 12, fontWeight: '600' },
  description: { fontSize: 15, color: colors.textSecondary, marginTop: spacing.lg, lineHeight: 22 },
  section: { marginTop: spacing.xl },
  sectionTitle: { fontSize: 18, fontWeight: '600', color: colors.textPrimary, marginBottom: spacing.md },
  specRow: { flexDirection: 'row', paddingVertical: spacing.sm, borderBottomWidth: 1, borderBottomColor: colors.border },
  specKey: { flex: 1, fontSize: 14, color: colors.textTertiary },
  specVal: { flex: 1, fontSize: 14, color: colors.textPrimary },
  reviewCard: { marginBottom: spacing.md, padding: spacing.md, backgroundColor: colors.surface, borderRadius: radii.md, borderWidth: 1, borderColor: colors.border },
  reviewHeader: { flexDirection: 'row', justifyContent: 'space-between' },
  reviewAuthor: { fontSize: 14, fontWeight: '600', color: colors.textPrimary },
  reviewRating: { fontSize: 13, color: '#F59E0B' },
  reviewComment: { fontSize: 14, color: colors.textSecondary, marginTop: 4 },
  addButton: { backgroundColor: colors.textPrimary, borderRadius: radii.md, paddingVertical: 18, alignItems: 'center', marginTop: spacing.xl, marginBottom: 40 },
  addButtonText: { color: colors.textInverse, fontSize: 16, fontWeight: '600' },
});
