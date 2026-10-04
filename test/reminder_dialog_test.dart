import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabletime/main.dart';

void main() {
  testWidgets('Bell icon tap opens Booking Reminder popup window with seat and pre-ordered food',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // 1. Launch App
    await tester.pumpWidget(const TableTimeApp());
    await tester.pumpAndSettle();

    // 2. Locate Bell Icon button on Top Right
    final bellIconFinder = find.byIcon(Icons.notifications_active_rounded);
    expect(bellIconFinder, findsOneWidget);

    // 3. Tap Bell Icon
    await tester.tap(bellIconFinder);
    await tester.pumpAndSettle();

    // 4. Verify Popup Window Dialog Opened
    expect(find.text('Dining & Seat Reminder'), findsOneWidget);
    expect(find.text('Pre-Ordered Food'), findsOneWidget);
    expect(find.textContaining('Reserved for 8:30 PM'), findsOneWidget);
    expect(find.text('Margherita Pizza'), findsOneWidget);
    expect(find.text('Paneer Tikka Angaara'), findsOneWidget);
    expect(find.text('Fresh Lime Soda'), findsOneWidget);

    // 5. Tap "Got it, Thanks!" to close dialog
    final closeBtnFinder = find.text('Got it, Thanks!');
    expect(closeBtnFinder, findsOneWidget);
    await tester.tap(closeBtnFinder);
    await tester.pumpAndSettle();

    // Verify dialog is dismissed
    expect(find.text('Dining & Seat Reminder'), findsNothing);
  });
}
