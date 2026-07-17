import * as React from 'react';
import { cn } from '@/lib/utils';

const Input = React.forwardRef<HTMLInputElement, React.InputHTMLAttributes<HTMLInputElement>>(
  ({ className, type, ...props }, ref) => (
    <input
      type={type}
      className={cn(
        'flex h-10 w-full rounded-md border border-vendi-border bg-white px-3 py-2 text-sm',
        'text-vendi-text-primary placeholder:text-vendi-text-tertiary',
        'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-vendi-text-primary/20',
        'disabled:cursor-not-allowed disabled:opacity-50',
        className,
      )}
      ref={ref}
      {...props}
    />
  ),
);
Input.displayName = 'Input';

export { Input };
