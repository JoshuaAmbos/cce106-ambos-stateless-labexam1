import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stateless_lab_exam/main.dart';
import 'package:stateless_lab_exam/shopping_cart_page.dart';

void main() {
  testWidgets('ShoppingCartPage renders all required sections', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    // 1. AppBar
    expect(find.text('My Cart'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
    expect(find.text('3'), findsOneWidget); // Badge text

    // 2. Introduction Section
    expect(find.text('CAMPUS STORE'), findsOneWidget);
    expect(find.text('Ready for checkout'), findsOneWidget);
    expect(
      find.text('Review your items before placing your order.'),
      findsOneWidget,
    );

    // 3. Delivery Information Card
    expect(find.byIcon(Icons.location_on), findsOneWidget);
    expect(find.textContaining('Deliver to'), findsOneWidget);
    expect(find.text('Matina, Davao City'), findsOneWidget);
    expect(find.text('Change'), findsOneWidget);

    // 4. Order Items
    expect(find.text('Order Items'), findsOneWidget);
    expect(find.text('3 items'), findsOneWidget);
    expect(find.byType(CartItemCard), findsNWidgets(3));
    expect(find.text('Wireless Mouse'), findsOneWidget);
    expect(find.text('PHP 450.00'), findsOneWidget);
    expect(find.text('USB-C Hub'), findsOneWidget);
    expect(find.text('PHP 850.00'), findsOneWidget);
    expect(find.text('Laptop Stand'), findsOneWidget);
    expect(find.text('PHP 700.00'), findsOneWidget);

    // 5. Discount Banner
    expect(find.text('STUDENT10 applied'), findsOneWidget);
    expect(find.text('10% discount on items'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);

    // 6. Payment Summary
    expect(find.text('Payment Summary'), findsOneWidget);
    expect(find.text('Subtotal'), findsOneWidget);
    expect(find.text('PHP 2,000.00'), findsOneWidget);
    expect(find.text('Discount (10%)'), findsOneWidget);
    expect(find.text('- PHP 200.00'), findsOneWidget);
    expect(find.text('Delivery Fee'), findsOneWidget);
    expect(find.text('PHP 50.00'), findsOneWidget);
    expect(find.text('Total'), findsOneWidget);
    expect(find.text('PHP 1,850.00'), findsOneWidget);

    // 7. Place Order Button
    expect(find.text('Place Order'), findsOneWidget);
    expect(find.byIcon(Icons.lock), findsOneWidget);
  });

  testWidgets('Button interactions execute and print required console outputs', (
    WidgetTester tester,
  ) async {
    final List<String> logs = [];
    final originalDebugPrint = debugPrint;
    debugPrint = (String? message, {int? wrapWidth}) {
      if (message != null) logs.add(message);
    };

    try {
      await tester.pumpWidget(const MyApp());

      // Tap back arrow
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pump();
      expect(logs, contains('Back clicked'));

      // Tap shopping bag
      await tester.tap(find.byIcon(Icons.shopping_bag_outlined));
      await tester.pump();
      expect(logs, contains('Cart clicked'));

      // Tap Change
      await tester.tap(find.text('Change'));
      await tester.pump();
      expect(logs, contains('Change delivery address clicked'));

      // Item 1: Wireless Mouse
      await tester.tap(find.byIcon(Icons.remove).at(0));
      await tester.pump();
      expect(logs, contains('Decrease quantity: Wireless Mouse'));

      await tester.tap(find.byIcon(Icons.add).at(0));
      await tester.pump();
      expect(logs, contains('Increase quantity: Wireless Mouse'));

      await tester.tap(find.byIcon(Icons.delete_outline_rounded).at(0));
      await tester.pump();
      expect(logs, contains('Remove item: Wireless Mouse'));

      // Item 2: USB-C Hub
      await tester.tap(find.byIcon(Icons.remove).at(1));
      await tester.pump();
      expect(logs, contains('Decrease quantity: USB-C Hub'));

      await tester.tap(find.byIcon(Icons.add).at(1));
      await tester.pump();
      expect(logs, contains('Increase quantity: USB-C Hub'));

      await tester.tap(find.byIcon(Icons.delete_outline_rounded).at(1));
      await tester.pump();
      expect(logs, contains('Remove item: USB-C Hub'));

      // Item 3: Laptop Stand (scroll into view)
      await tester.ensureVisible(find.text('Laptop Stand'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.remove).at(2));
      await tester.pump();
      expect(logs, contains('Decrease quantity: Laptop Stand'));

      await tester.tap(find.byIcon(Icons.add).at(2));
      await tester.pump();
      expect(logs, contains('Increase quantity: Laptop Stand'));

      await tester.tap(find.byIcon(Icons.delete_outline_rounded).at(2));
      await tester.pump();
      expect(logs, contains('Remove item: Laptop Stand'));

      // Scroll to Place Order button and tap
      await tester.ensureVisible(find.text('Place Order'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Place Order'));
      await tester.pump();
      expect(logs, contains('Place order clicked! Total: PHP 1850.00'));
    } finally {
      debugPrint = originalDebugPrint;
    }
  });

  for (final size in [
    const Size(320, 568), // iPhone SE 1st gen (narrow)
    const Size(360, 640), // Android compact
    const Size(375, 667), // iPhone 8
    const Size(390, 844), // iPhone 12/13/14
    const Size(412, 915), // Pixel 7
    const Size(800, 1200), // Tablet
  ]) {
    testWidgets('No layout overflow on screen size $size', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      expect(find.text('My Cart'), findsOneWidget);
    });
  }
}
