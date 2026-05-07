import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:movie_explorer/main.dart';

void main() {
  testWidgets('affiche le titre de l application', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(MyApp(preferences: preferences));
    expect(find.text('Movie Explorer'), findsOneWidget);
  });
}