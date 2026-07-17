import { Link, Outlet, useNavigate } from 'react-router-dom';
import { useAppAuth } from '@/context/AuthContext';
import { Button } from '@/components/ui/button';

const NAV = [
  { label: 'Home', path: '/' },
  { label: 'Search', path: '/search' },
  { label: 'Cart', path: '/cart' },
  { label: 'Orders', path: '/orders' },
  { label: 'Profile', path: '/profile' },
];

export function Layout() {
  const { isAuthenticated, user, logout } = useAppAuth();
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-white flex flex-col">
      {/* Sidebar for desktop */}
      {isAuthenticated && (
        <aside className="fixed left-0 top-0 h-full w-56 border-r border-vendi-border bg-white p-4 flex flex-col">
          <Link to="/" className="text-xl font-bold text-vendi-text-primary mb-8 block">
            Vendi
          </Link>
          <nav className="flex-1 space-y-1">
            {NAV.map((item) => (
              <Link
                key={item.path}
                to={item.path}
                className="block px-3 py-2 text-sm font-medium text-vendi-text-secondary hover:text-vendi-text-primary hover:bg-vendi-surface rounded-md transition-colors"
              >
                {item.label}
              </Link>
            ))}
          </nav>
          <div className="border-t border-vendi-border pt-4 mt-4">
            <p className="text-sm text-vendi-text-primary truncate">{user?.name ?? user?.email}</p>
            <Button variant="ghost" size="sm" className="mt-1 w-full justify-start" onClick={async () => { await logout(); navigate('/login'); }}>
              Sign Out
            </Button>
          </div>
        </aside>
      )}

      {/* Main content */}
      <div className={isAuthenticated ? 'ml-56' : ''}>
        <main className="max-w-6xl mx-auto px-6 py-6">
          <Outlet />
        </main>
      </div>
    </div>
  );
}
