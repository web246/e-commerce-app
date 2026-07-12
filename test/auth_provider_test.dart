import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dennis_mendez_app/providers/auth_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('demo login accepts the requested credentials', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final authProvider = AuthProvider(prefs);

    await authProvider.login('slappygenius6@gmail.com', '12345678');

    expect(authProvider.isAuthenticated, isTrue);
    expect(authProvider.user?.email, 'slappygenius6@gmail.com');
    expect(authProvider.user?.role, 'customer');
  });
}
