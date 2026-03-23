import 'package:flutter_test/flutter_test.dart';

import 'package:app_hoctap/main.dart';
import 'package:app_hoctap/di/injection_container.dart';

void main() {
  testWidgets('Login page renders key UI elements', (WidgetTester tester) async {
    await initializeDependencies();

    await tester.pumpWidget(const MyApp());

    expect(find.text('Đăng nhập'), findsOneWidget);
    expect(find.text('Chào mừng bạn\ntrở lại'), findsOneWidget);
    expect(find.text('Đăng ký ngay'), findsOneWidget);
  });
}
