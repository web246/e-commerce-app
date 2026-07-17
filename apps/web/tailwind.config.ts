import type { Config } from 'tailwindcss';

export default {
  content: ['./index.html', './src/**/*.{ts,tsx}'],
  theme: {
    extend: {
      colors: {
        vendi: {
          background: '#FFFFFF',
          surface: '#F8FAFC',
          'surface-hover': '#F1F5F9',
          border: '#F1F5F9',
          'border-strong': '#E2E8F0',
          'text-primary': '#0F172A',
          'text-secondary': '#475569',
          'text-tertiary': '#94A3B8',
          'text-inverse': '#FFFFFF',
          accent: '#2563EB',
          'accent-hover': '#1D4ED8',
          error: '#EF4444',
          success: '#10B981',
        },
      },
      borderRadius: {
        sm: '10px',
        md: '14px',
        lg: '20px',
        xl: '24px',
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
      },
    },
  },
  plugins: [],
} satisfies Config;
