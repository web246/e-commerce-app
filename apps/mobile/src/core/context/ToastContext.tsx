// Vendi ToastContext — global `showToast()` function for snackbar notifications.

import React, { createContext, useContext, useState, useCallback, useRef, type ReactNode } from 'react';
import { Toast, type ToastVariant } from '../ui/Toast';

interface ToastCtx {
  showToast: (message: string, variant?: ToastVariant, duration?: number) => void;
}

const ToastContext = createContext<ToastCtx>({} as ToastCtx);

export function ToastProvider({ children }: { children: ReactNode }) {
  const [toast, setToast] = useState<{ message: string; variant: ToastVariant; duration: number } | null>(null);
  const toastId = useRef(0);

  const showToast = useCallback((message: string, variant: ToastVariant = 'info', duration = 3000) => {
    toastId.current += 1;
    setToast({ message, variant, duration });
  }, []);

  const handleHide = useCallback(() => {
    setToast(null);
  }, []);

  return (
    <ToastContext.Provider value={{ showToast }}>
      {children}
      {toast && (
        <Toast
          key={toastId.current}
          message={toast.message}
          variant={toast.variant}
          duration={toast.duration}
          visible
          onHide={handleHide}
        />
      )}
    </ToastContext.Provider>
  );
}

export function useToast() {
  return useContext(ToastContext);
}
