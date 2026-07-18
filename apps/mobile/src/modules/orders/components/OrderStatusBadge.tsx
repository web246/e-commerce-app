import React from 'react';
import { Badge, BadgeVariant } from '../../../core/ui';

const STATUS_BADGE_VARIANT: Record<string, BadgeVariant> = {
  pending: 'warning',
  confirmed: 'info',
  processing: 'info',
  shipped: 'info',
  delivered: 'success',
  cancelled: 'error',
};

interface OrderStatusBadgeProps {
  status: string;
}

export function OrderStatusBadge({ status }: OrderStatusBadgeProps) {
  const variant = STATUS_BADGE_VARIANT[status] ?? 'default';
  return <Badge variant={variant}>{status}</Badge>;
}
