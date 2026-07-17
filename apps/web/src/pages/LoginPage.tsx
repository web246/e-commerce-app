import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useAppAuth } from '@/context/AuthContext';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';

export default function LoginPage() {
  const { login, googleSignIn, resetPassword } = useAppAuth();
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [googleLoading, setGoogleLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!email.trim() || !password) { setError('Enter email and password'); return; }
    setError(null);
    setLoading(true);
    try {
      await login(email.trim(), password);
      navigate('/');
    } catch {
      setError('Invalid email or password');
    } finally {
      setLoading(false);
    }
  };

  const handleGoogle = async () => {
    setError(null);
    setGoogleLoading(true);
    try {
      await googleSignIn();
      navigate('/');
    } catch {
      setError('Google sign-in failed');
    } finally {
      setGoogleLoading(false);
    }
  };

  const handleForgot = async () => {
    if (!email.trim()) { setError('Enter your email to reset password'); return; }
    try {
      await resetPassword(email.trim());
      setError(null);
      alert('Check your email for a password reset link');
    } catch {
      setError('Failed to send reset email');
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center px-4">
      <div className="w-full max-w-sm">
        <h1 className="text-3xl font-bold text-center text-vendi-text-primary mb-1">Vendi</h1>
        <p className="text-center text-vendi-text-secondary mb-8">Sign in to your account</p>

        {error && (
          <div className="bg-red-50 text-vendi-error text-sm text-center p-3 rounded-md mb-4">
            {error}
          </div>
        )}

        <form onSubmit={handleLogin} className="space-y-4">
          <Input
            type="email"
            placeholder="Email address"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            autoComplete="email"
            required
          />
          <Input
            type="password"
            placeholder="Password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            autoComplete="current-password"
            required
          />
          <Button type="submit" className="w-full" disabled={loading}>
            {loading ? 'Signing in...' : 'Sign In'}
          </Button>
        </form>

        <div className="relative my-6">
          <div className="absolute inset-0 flex items-center"><span className="w-full border-t border-vendi-border" /></div>
          <div className="relative flex justify-center text-xs"><span className="bg-white px-2 text-vendi-text-tertiary">or</span></div>
        </div>

        <Button variant="outline" className="w-full" disabled={googleLoading} onClick={handleGoogle}>
          {googleLoading ? 'Connecting...' : 'Continue with Google'}
        </Button>

        <div className="mt-6 text-center space-y-3">
          <button onClick={handleForgot} className="text-sm text-vendi-accent hover:underline">
            Forgot password?
          </button>
          <div>
            <Link to="/register" className="text-sm text-vendi-accent hover:underline">
              Don't have an account? Create one
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}
