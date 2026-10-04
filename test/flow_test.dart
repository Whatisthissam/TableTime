import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabletime/main.dart';

void main() {
  testWidgets('Complete End-to-End Functional Flow Test', (WidgetTester tester) async {
    // Set typical mobile phone dimensions (e.g., iPhone 14 / modern Android)
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // 1. Launch App
    await tester.pumpWidget(const TableTimeApp());
    await tester.pumpAndSettle();

    // Verify Home Screen loaded
    expect(find.text('TableTime'), findsWidgets);
    expect(find.text('Reserve Now'), findsOneWidget);

    // 2. Scroll to and tap "Reserve Now"
    await tester.ensureVisible(find.text('Reserve Now'));
    await tester.tap(find.text('Reserve Now'));
    await tester.pumpAndSettle();

    expect(find.text('Restaurant Detail'), findsOneWidget);
    expect(find.text('Choose Your Table'), findsOneWidget);

    // 3. Test Party size quick select '4'
    await tester.tap(find.text('4'));
    await tester.pumpAndSettle();
    expect(find.text('4 Guests'), findsWidgets);

    // Test Time slot selection '8:00 PM'
    await tester.tap(find.text('8:00 PM'));
    await tester.pumpAndSettle();

    // 4. Scroll to and tap "Choose Your Table"
    await tester.ensureVisible(find.text('Choose Your Table'));
    await tester.tap(find.text('Choose Your Table'));
    await tester.pumpAndSettle();

    expect(find.text('Table Selector'), findsOneWidget);
    expect(find.text('Continue to Menu'), findsOneWidget);

    // 5. Test selecting table
    // T-01 is available
    await tester.tap(find.text('T-01'));
    await tester.pumpAndSettle();
    expect(find.text('T-01 Selected'), findsOneWidget);

    // 6. Test tapping occupied table T-02 (should remain on T-01)
    await tester.tap(find.text('T-02'));
    await tester.pumpAndSettle();
    expect(find.text('T-01 Selected'), findsOneWidget); // still T-01

    // 7. Navigate to Menu
    await tester.tap(find.text('Continue to Menu'));
    await tester.pumpAndSettle();

    expect(find.text('Menu & Pre Order Selection'), findsOneWidget);
    expect(find.text('What would you like to\neat?'), findsOneWidget);

    // 8. Test Category Filtering
    await tester.ensureVisible(find.text('Pizza'));
    await tester.tap(find.text('Pizza'));
    await tester.pumpAndSettle();
    expect(find.text('Margherita Pizza'), findsOneWidget);
    expect(find.text('Classic Cheeseburger'), findsNothing);

    await tester.ensureVisible(find.text('Burgers'));
    await tester.tap(find.text('Burgers'));
    await tester.pumpAndSettle();
    expect(find.text('Classic Cheeseburger'), findsOneWidget);
    expect(find.text('Margherita Pizza'), findsNothing);

    await tester.ensureVisible(find.text('All'));
    await tester.ensureVisible(find.text('Pizza'));
    await tester.tap(find.text('Pizza'));
    await tester.pumpAndSettle();
    expect(find.text('Margherita Pizza'), findsOneWidget);

    // 9. Add Items to Cart
    final pizzaAddBtn = find.descendant(
      of: find.widgetWithText(Container, 'Margherita Pizza'),
      matching: find.byIcon(Icons.add),
    ).first;

    await tester.tap(pizzaAddBtn);
    await tester.pump(const Duration(milliseconds: 700)); // wait for flight animation
    await tester.pumpAndSettle();

    // Verify 1 item in cart
    expect(find.text('1 Items • ₹299'), findsOneWidget);

    // 10. Add Margherita Pizza again (quantity 2)
    await tester.tap(pizzaAddBtn);
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    expect(find.text('2 Items • ₹598'), findsOneWidget);

    // 11. Add another item: Cheeseburger
    await tester.ensureVisible(find.text('Burgers'));
    await tester.tap(find.text('Burgers'));
    await tester.pumpAndSettle();
    expect(find.text('Classic Cheeseburger'), findsOneWidget);

    final burgerAddBtn = find.descendant(
      of: find.widgetWithText(Container, 'Classic Cheeseburger'),
      matching: find.byIcon(Icons.add),
    ).first;

    await tester.tap(burgerAddBtn);
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    expect(find.text('3 Items • ₹947'), findsOneWidget);

    // 12. Open Cart Screen
    await tester.tap(find.text('View Cart'));
    await tester.pumpAndSettle();

    expect(find.text('Pre-Order Dishes'), findsOneWidget);
    expect(find.text('Continue to Checkout'), findsOneWidget);

    // 13. Test increase quantity in cart
    final plusButtons = find.byIcon(Icons.add);
    await tester.tap(plusButtons.first);
    await tester.pumpAndSettle();

    // 14. Test decrease quantity
    final minusButtons = find.byIcon(Icons.remove);
    await tester.tap(minusButtons.first);
    await tester.pumpAndSettle();

    // 15. Navigate to Checkout Screen
    await tester.ensureVisible(find.text('Continue to Checkout'));
    await tester.tap(find.text('Continue to Checkout'));
    await tester.pumpAndSettle();

    expect(find.text('Review Your Booking'), findsOneWidget);
    expect(find.text('Table Reservation'), findsOneWidget);
    expect(find.text('Payment Summary'), findsOneWidget);

    // 16. Confirm Reservation & Pre-Order
    final confirmFinder = find.byWidgetPredicate(
      (w) => w is Text && w.data != null && w.data!.startsWith('Confirm Reservation & Pre-Order'),
    );
    expect(confirmFinder, findsOneWidget);
    await tester.ensureVisible(confirmFinder);
    await tester.tap(confirmFinder);
    await tester.pumpAndSettle();

    // 17. Verify Confirmation Screen
    expect(find.text("You're All Set!"), findsOneWidget);
    expect(find.text('CONFIRMED RESERVATION'), findsOneWidget);
    expect(find.text('Back to Home'), findsOneWidget);

    // 18. Back to Home
    await tester.ensureVisible(find.text('Back to Home'));
    await tester.tap(find.text('Back to Home'));
    await tester.pumpAndSettle();

    // Verify back on Home and state reset
    expect(find.text('Reserve Now'), findsOneWidget);
  });
}
