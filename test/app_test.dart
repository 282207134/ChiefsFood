import 'package:chiefs_food/app.dart';
import 'package:chiefs_food/core/app_state.dart';
import 'package:chiefs_food/data/local_repository.dart';
import 'package:chiefs_food/data/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<AppState> freshState() async {
  SharedPreferences.setMockInitialValues({});
  return AppState(LocalRepository(await SharedPreferences.getInstance()));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'Cart totals, discount, duplicate lines and order snapshot persist',
    () async {
      final state = await freshState();
      state.add(foods[1], 2, 'Pepper');
      state.add(foods[5], 2, 'Pepper');
      state.add(foods[6], 1, 'Pepper');
      expect(state.subtotal, 3212);
      state.promo = true;
      expect(state.total, 2891);
      final order = state.placeOrder()!;
      expect(order.total, 2891);
      expect(order.count, 5);
      expect(state.cart, isEmpty);
      expect(state.placeOrder(), isNull);
      state.receive();
      state.favorite('salmon');
      state.dark = true;
      await state.persist();
      final restored = AppState(state.repository);
      expect(restored.dark, isTrue);
      expect(restored.favorites, contains('salmon'));
      expect(restored.latestOrder!.received, isTrue);
      expect(restored.latestOrder!.total, 2891);
    },
  );

  test('Cart removal and quantity limit are safe', () async {
    final state = await freshState();
    state.add(foods[0], 1, 'Tomato');
    state.add(foods[0], 99, 'Tomato');
    expect(state.cart.length, 1);
    expect(state.cart.first.quantity, 99);
    state.changeQuantity(state.cart.first, -99);
    expect(state.cart, isEmpty);
    expect(state.total, 0);
  });

  for (final size in [const Size(375, 812), const Size(320, 640)]) {
    for (final route in appRoutes.keys) {
      testWidgets('$route renders at ${size.width} with no layout exceptions', (
        tester,
      ) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final state = await freshState();
        state.cart.add(CartLine(foods[1], quantity: 2));
        state.orders.add(FoodOrder(id: '456723', total: 3212, count: 5));
        state.favorites.add('salmon');
        await tester.pumpWidget(
          ChiefsFoodApp(state: state, initialRoute: route),
        );
        await tester.pumpAndSettle();
        final error = tester.takeException();
        expect(error, isNull, reason: '$route\n$error');
      });
    }
  }

  testWidgets('Login form rejects invalid input', (tester) async {
    final state = await freshState();
    await tester.pumpWidget(
      ChiefsFoodApp(state: state, initialRoute: '/login'),
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Login'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a valid email address'), findsOneWidget);
    expect(find.text('Use at least 6 characters'), findsOneWidget);
  });
}
