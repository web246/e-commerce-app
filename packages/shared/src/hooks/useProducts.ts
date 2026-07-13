import { useState, useEffect } from 'react';
import { getProducts, getProductById, onProductsSnapshot } from '../firebase/firestore';
import type { Product } from '../types/models';

export function useProducts(opts?: { category?: string; featured?: boolean; bestSeller?: boolean; flashSale?: boolean; search?: string; limit?: number }) {
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    setLoading(true);
    getProducts(opts)
      .then(setProducts)
      .catch((e) => setError(e.message))
      .finally(() => setLoading(false));
  }, [opts?.category, opts?.featured, opts?.bestSeller, opts?.flashSale, opts?.search, opts?.limit]);

  return { products, loading, error, refetch: () => getProducts(opts).then(setProducts) };
}

export function useProduct(id: string) {
  const [product, setProduct] = useState<Product | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!id) return;
    setLoading(true);
    getProductById(id)
      .then(setProduct)
      .catch((e) => setError(e.message))
      .finally(() => setLoading(false));
  }, [id]);

  return { product, loading, error };
}

export function useLiveProducts(opts?: { category?: string; limit?: number }) {
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const unsub = onProductsSnapshot((data) => {
      setProducts(data);
      setLoading(false);
    }, opts);
    return () => unsub();
  }, [opts?.category, opts?.limit]);

  return { products, loading };
}
