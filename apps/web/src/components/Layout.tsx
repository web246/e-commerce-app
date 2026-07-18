import { Link, Outlet, useNavigate } from 'react-router-dom';
import { useAppAuth } from '@/context/AuthContext';
import { Button } from '@/components/ui/button';

const NAV_ITEMS = [
  { label: 'Home', path: '/' },
  { label: 'Search', path: '/search' },
  { label: 'Cart', path: '/cart' },
  { label: 'Orders', path: '/orders' },
  { label: 'Profile', path: '/profile' },
];

export function Layout() {
  const { isAuthenticated, user, logout } = useAppAuth();
  const navigate = useNavigate();

  const handleLogout = async () => {
    await logout();
    navigate('/login');
  };

  return (
    <div className="min-h-screen bg-white">
      {/* Nav */}
      <header className="sticky top-0 z-50 border-b border-vendi-border bg-white/95 backdrop-blur supports-[backdrop-filter]:bg-white/80">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            <Link to="/" className="text-xl font-bold text-vendi-text-primary">
              Vendi
            </Link>

            {isAuthenticated && (
              <nav className="hidden md:flex items-center gap-6">
                {NAV_ITEMS.map((item) => (
                  <Link
                    key={item.path}
                    to={item.path}
                    className="text-sm font-medium text-vendi-text-secondary hover:text-vendi-text-primary transition-colors"
                  >
                    {item.label}
                  </Link>
                ))}
              </nav>
            )}

            <div className="flex items-center gap-3">
              {isAuthenticated ? (
                <>
                  <span className="text-sm text-vendi-text-tertiary hidden sm:block">
                    {user?.name ?? user?.email}
                  </span>
                  <Button variant="outline" size="sm" onClick={handleLogout}>
                    Sign Out
                  </Button>
                </>
              ) : (
                <Button variant="default" size="sm" onClick={() => navigate('/login')}>
                  Sign In
                </Button>
              )}
            </div>
          </div>

          {/* Mobile nav */}
          {isAuthenticated && (
            <div className="flex md:hidden items-center gap-4 pb-3 overflow-x-auto">
              {NAV_ITEMS.map((item) => (
                <Link
                  key={item.path}
                  to={item.path}
                  className="text-sm font-medium text-vendi-text-secondary hover:text-vendi-text-primary whitespace-nowrap"
                >
                  {item.label}
                </Link>
              ))}
            </div>
          )}
        </div>
      </header>

      {/* Content */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
        <Outlet />
      </main>
    </div>
  );
}
