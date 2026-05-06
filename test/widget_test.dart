import 'package:flutter_test/flutter_test.dart';

import 'package:movie_explorer/main.dart';

void main() {
  testWidgets('affiche le titre de l application', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Movie Explorer'), findsOneWidget);
  });
}
