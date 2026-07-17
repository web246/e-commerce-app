import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useAppAuth } from '@/context/AuthContext';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';

export default function RegisterPage() {
  const { register } = useAppAuth();
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirm, setConfirm] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleRegister = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!email.trim() || !password) { setError('All fields required'); return; }
    if (password.length < 8) { setError('Password must be at least 8 characters'); return; }
    if (password !== confirm) { setError('Passwords do not match'); return; }
    setError(null); setLoading(true);
    try { await register(email.trim(), password); navigate('/'); }
    catch { setError('Registration failed'); }
    finally { setLoading(false); }
  };

  return (
    <div className="min-h-screen flex items-center justify-center">
      <div className="w-full max-w-sm">
        <h1 className="text-3xl font-bold text-center text-vendi-text-primary mb-1">Create Account</h1>
        <p className="text-center text-vendi-text-secondary mb-8">Join Vendi today</p>
        {error && <div className="bg-red-50 text-vendi-error text-sm text-center p-3 rounded-md mb-4">{error}</div>}
        <form onSubmit={handleRegister} className="space-y-4">
          <Input type="email" placeholder="Email" value={email} onChange={e => setEmail(e.target.value)} required />
          <Input type="password" placeholder="Password (min 8)" value={password} onChange={e => setPassword(e.target.value)} required />
          <Input type="password" placeholder="Confirm password" value={confirm} onChange={e => setConfirm(e.target.value)} required />
          <Button type="submit" className="w-full" disabled={loading}>{loading ? 'Creating account...' : 'Create Account'}</Button>
        </form>
        <div className="mt-6 text-center">
          <Link to="/login" className="text-sm text-vendi-accent hover:underline">Already have an account? Sign in</Link>
        </div>
      </div>
    </div>
  );
}
