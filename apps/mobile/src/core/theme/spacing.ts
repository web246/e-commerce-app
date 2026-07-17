// Vendi spacing system — single source of truth for all layout values

export const spacing = {
  /** 4px — tightest */
  xxs: 4,
  /** 8px */
  xs: 8,
  /** 12px */
  sm: 12,
  /** 16px — base unit */
  md: 16,
  /** 20px */
  cardPadding: 20,
  /** 24px */
  lg: 24,
  /** 32px */
  xl: 32,
  /** 40px */
  xxl: 40,
  /** 56px */
  xxxl: 56,
  /** Section gap between major screen sections */
  sectionGap: 40,
} as const;

export const radii = {
  sm: 10,
  md: 14,
  lg: 20,
  xl: 24,
  full: 999,
} as const;

export const motion = {
  fast: 150,
  normal: 200,
  slow: 300,
} as const;

/** Screen edge padding — consistent across all screens */
export const screenPadding = spacing.cardPadding;
