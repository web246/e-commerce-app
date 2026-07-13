import { useState, useEffect } from 'react';
import { getReviews, getAverageRating, addReview } from '../firebase/firestore';
import type { Review } from '../types/models';

export function useReviews(productId: string) {
  const [reviews, setReviews] = useState<Review[]>([]);
  const [average, setAverage] = useState(0);
  const [count, setCount] = useState(0);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!productId) return;
    Promise.all([getReviews(productId), getAverageRating(productId)])
      .then(([r, { average: avg, count: c }]) => {
        setReviews(r);
        setAverage(avg);
        setCount(c);
      })
      .finally(() => setLoading(false));
  }, [productId]);

  const submitReview = async (data: Omit<Review, 'id' | 'createdAt'>) => {
    await addReview(data);
    // Refresh
    const [r, { average: avg, count: c }] = await Promise.all([getReviews(productId), getAverageRating(productId)]);
    setReviews(r);
    setAverage(avg);
    setCount(c);
  };

  return { reviews, average, count, loading, submitReview };
}
