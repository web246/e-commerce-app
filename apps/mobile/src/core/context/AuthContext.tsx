import React, { createContext, useContext, useCallback, useMemo } from 'react';
import {
  useAuth,
  signInWithEmail,
  registerWithEmail,
  signOutUser,
  sendPasswordReset,
  signInWithGoogleRedirect,
} from '@vendi/shared';
import type { User } from '@vendi/shared';

interface AuthCtx {
  user: User | null;
  isAuthenticated: boolean;
  loading: boolean;
  initialized: boolean;
  isAdmin: boolean;
  isSeller: boolean;
  login: (email: string, password: string) => Promise<void>;
  register: (email: string, password: string) => Promise<void>;
  logout: () => Promise<void>;
  resetPassword: (email: string) => Promise<void>;
  googleSignIn: () => Promise<void>;
}

const AuthContext = createContext<AuthCtx>({} as AuthCtx);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const { user, loading, initialized, isAuthenticated, isAdmin, isSeller } = useAuth();

  const login = useCallback(async (email: string, password: string) => {
    await signInWithEmail(email, password);
  }, []);

  const register = useCallback(async (email: string, password: string) => {
    await registerWithEmail(email, password);
  }, []);

  const logout = useCallback(async () => {
    await signOutUser();
  }, []);

  const resetPassword = useCallback(async (email: string) => {
    await sendPasswordReset(email);
  }, []);

  const googleSignIn = useCallback(async () => {
    await signInWithGoogleRedirect();
  }, []);

  const value = useMemo<AuthCtx>(() => ({
    user,
    isAuthenticated,
    loading,
    initialized,
    isAdmin,
    isSeller,
    login,
    register,
    logout,
    resetPassword,
    googleSignIn,
  }), [user, isAuthenticated, loading, initialized, isAdmin, isSeller, login, register, logout, resetPassword, googleSignIn]);

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAppAuth() {
  return useContext(AuthContext);
}
