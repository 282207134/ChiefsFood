import 'package:chiefs_food/app.dart';
import 'package:chiefs_food/core/app_state.dart';
import 'package:chiefs_food/data/local_repository.dart';
import 'package:chiefs_food/data/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Ordering flow and complete light/dark screenshot gallery', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final state = AppState(
      LocalRepository(await SharedPreferences.getInstance()),
    );
    final nav = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      ChiefsFoodApp(state: state, initialRoute: '/menu', navigatorKey: nav),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Healthy Chicken with Salad'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(r'Add to cart · $12.56'));
    await tester.pumpAndSettle();
    expect(state.count, 1);
    await tester.tap(find.text(r'Checkout · $12.56'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue to payment'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(r'Confirm demo order · $12.56'));
    await tester.pumpAndSettle();
    expect(state.latestOrder!.total, 1256);
    expect(state.cart, isEmpty);
    await tester.tap(find.text('Track your order'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mark demo order as received'));
    await tester.pumpAndSettle();
    expect(state.latestOrder!.received, isTrue);
    expect(find.text('You received the order!'), findsOneWidget);

    // Deterministic local data keeps the documentation screenshots reproducible.
    state.orders.clear();
    state.orders.add(FoodOrder(id: '456723', total: 3212, count: 5));
    state.add(foods[1], 2, 'Pepper');
    state.add(foods[5], 2, 'Pepper');
    state.add(foods[6], 1, 'Pepper');
    state.favorite('salmon');
    await binding.convertFlutterSurfaceToImage();
    for (final dark in [false, true]) {
      state.dark = dark;
      await state.persist();
      for (final route in appRoutes.keys) {
        nav.currentState!.pushNamedAndRemoveUntil(route, (_) => false);
        await tester.pumpAndSettle();
        await tester.pump(const Duration(milliseconds: 250));
        expect(tester.takeException(), isNull, reason: route);
        await binding.takeScreenshot(
          '${dark ? 'dark' : 'light'}${route.replaceAll('/', '_')}',
        );
      }
      final prefix = dark ? 'dark' : 'light';
      Future<void> open(String route) async {
        nav.currentState!.pushNamedAndRemoveUntil(route, (_) => false);
        await tester.pumpAndSettle();
      }

      await open('/login');
      await tester.tap(find.widgetWithText(FilledButton, 'Login'));
      await tester.pumpAndSettle();
      expect(find.text('Enter a valid email address'), findsOneWidget);
      await binding.takeScreenshot('${prefix}_login-error');
      await open('/verify');
      await tester.tap(find.text('Verify & continue'));
      await tester.pumpAndSettle();
      expect(find.text('Use the demo code 1234'), findsOneWidget);
      await binding.takeScreenshot('${prefix}_verify-error');
      final savedCart = state.cart.toList();
      state.cart.clear();
      await state.persist();
      await open('/cart');
      expect(find.text('Your cart is waiting'), findsOneWidget);
      await binding.takeScreenshot('${prefix}_cart-empty');
      state.cart.addAll(savedCart);
      await state.persist();
      await open('/search');
      await tester.enterText(find.byType(TextField).first, 'zzzz');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      expect(find.text('No meals found'), findsOneWidget);
      await binding.takeScreenshot('${prefix}_search-empty');
      await open('/methods');
      await tester.tap(find.text('Add demo payment method'));
      await tester.pumpAndSettle();
      expect(find.text('Add a payment method'), findsOneWidget);
      await binding.takeScreenshot('${prefix}_payment-sheet');
    }
    state.dark = false;
    state.onboarded = true;
    await state.persist();
    nav.currentState!.pushNamedAndRemoveUntil('/home', (_) => false);
    await tester.pumpAndSettle();
  });
}
