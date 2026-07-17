'use client';

import { useState, useEffect, useCallback } from 'react';
import { onAuthChanged } from '../firebase/auth';
import { getUserProfile } from '../firebase/firestore';
import type { User } from '../types/models';

interface AuthState {
  user: User | null;
  loading: boolean;
  initialized: boolean;
}

export function useAuth() {
  const [state, setState] = useState<AuthState>({
    user: null,
    loading: true,
    initialized: false,
  });

  useEffect(() => {
    const unsubscribe = onAuthChanged(async (firebaseUser) => {
      if (firebaseUser) {
        try {
          const profile = await getUserProfile(firebaseUser.uid);
          setState({
            user: profile ?? {
              id: firebaseUser.uid,
              name: firebaseUser.displayName ?? firebaseUser.email ?? '',
              email: firebaseUser.email ?? '',
              role: 'customer' as const,
              isVerified: firebaseUser.emailVerified,
            },
            loading: false,
            initialized: true,
          });
        } catch {
          setState({
            user: {
              id: firebaseUser.uid,
              name: firebaseUser.email ?? '',
              email: firebaseUser.email ?? '',
              role: 'customer' as const,
              isVerified: firebaseUser.emailVerified,
            },
            loading: false,
            initialized: true,
          });
        }
      } else {
        setState({ user: null, loading: false, initialized: true });
      }
    });

    return () => unsubscribe();
  }, []);

  return {
    user: state.user,
    loading: state.loading,
    initialized: state.initialized,
    isAuthenticated: !!state.user,
    isAdmin: state.user?.role === 'admin',
    isSeller: state.user?.role === 'seller',
  };
}
