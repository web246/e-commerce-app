import { useNavigate } from 'react-router-dom';
import { useAppAuth } from '@/context/AuthContext';
import { Button } from '@/components/ui/button';

export default function ProfilePage() {
  const { user, logout } = useAppAuth();
  const navigate = useNavigate();

  const handleLogout = async () => {
    await logout();
    navigate('/login');
  };

  return (
    <div className="max-w-md mx-auto">
      <h1 className="text-2xl font-bold text-vendi-text-primary mb-6">Profile</h1>

      {/* Profile card */}
      <div className="flex items-center gap-4 border border-vendi-border rounded-lg p-6 bg-vendi-surface mb-8">
        <div className="w-16 h-16 rounded-full bg-vendi-text-primary flex items-center justify-center">
          <span className="text-2xl font-bold text-white">
            {(user?.name ?? 'U')[0].toUpperCase()}
          </span>
        </div>
        <div>
          <h2 className="text-lg font-semibold text-vendi-text-primary">
            {user?.name ?? 'User'}
          </h2>
          <p className="text-sm text-vendi-text-secondary">{user?.email}</p>
          <span className="inline-block mt-1 text-xs font-medium text-vendi-text-secondary bg-vendi-surface-hover px-2 py-0.5 rounded-full capitalize">
            {user?.role}
          </span>
        </div>
      </div>

      {/* Menu */}
      <div className="border border-vendi-border rounded-lg overflow-hidden mb-8">
        {['Edit Profile', 'Addresses', 'Payment Methods', 'Notifications'].map((item) => (
          <button
            key={item}
            className="w-full flex items-center justify-between px-6 py-4 text-sm text-vendi-text-primary hover:bg-vendi-surface transition-colors border-b border-vendi-border last:border-b-0"
            onClick={() => alert(`${item} — Coming soon`)}
          >
            <span>{item}</span>
            <span className="text-vendi-text-tertiary">→</span>
          </button>
        ))}
      </div>

      <Button
        variant="destructive"
        className="w-full"
        onClick={handleLogout}
      >
        Sign Out
      </Button>
    </div>
  );
}
