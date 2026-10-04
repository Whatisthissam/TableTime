import 'package:flutter_test/flutter_test.dart';
import 'package:tabletime/main.dart';

void main() {
  testWidgets('TableTimeApp smoke test loads HomeScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const TableTimeApp());
    await tester.pumpAndSettle();

    // Verify that TableTime branding is rendered
    expect(find.text('TableTime'), findsWidgets);
    expect(find.text('Reserve Now'), findsOneWidget);
  });
}
