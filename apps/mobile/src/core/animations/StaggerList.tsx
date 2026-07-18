import React, { type ReactElement } from 'react';
import { FadeInView } from './FadeInView';

interface StaggerListProps<T> {
  items: T[];
  renderItem: (item: T, index: number) => ReactElement;
  baseDelay?: number;
  staggerMs?: number;
  duration?: number;
}

/**
 * Renders an array of items with staggered fade+slide entrance animations.
 * Each item fades in sequentially with `staggerMs` between them.
 *
 * Usage:
 * ```tsx
 * <StaggerList items={products} renderItem={(item) => <Card ... />} />
 * ```
 */
export function StaggerList<T>({
  items,
  renderItem,
  baseDelay = 0,
  staggerMs = 80,
  duration = 350,
}: StaggerListProps<T>) {
  return (
    <>
      {items.map((item, index) => (
        <FadeInView key={index} delay={baseDelay + index * staggerMs} duration={duration}>
          {renderItem(item, index)}
        </FadeInView>
      ))}
    </>
  );
}
