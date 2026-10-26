import 'package:flutter/material.dart';

import '../data/local_repository.dart';
import '../data/models.dart';

class AppState extends ChangeNotifier {
  AppState(this.repository) {
    final data = repository.read();
    dark = data['dark'] == true;
    onboarded = data['onboarded'] == true;
    name = data['name'] as String? ?? 'Jhon David';
    email = data['email'] as String? ?? 'jhondavid45@gmail.com';
    address = data['address'] as String? ?? '143 New Star Building, Ontario';
    phone = data['phone'] as String? ?? '+1234567890';
    favorites.addAll((data['favorites'] as List? ?? []).whereType<String>());
    for (final item in data['cart'] as List? ?? []) {
      if (item is Map<String, dynamic>) {
        final line = CartLine.fromJson(item);
        if (line != null) cart.add(line);
      }
    }
    for (final item in data['orders'] as List? ?? []) {
      try {
        orders.add(FoodOrder.fromJson(item as Map<String, dynamic>));
      } catch (_) {
        /* Ignore malformed legacy demo records. */
      }
    }
  }
  final LocalRepository repository;
  bool dark = false, onboarded = false, promo = false;
  String name = '', email = '', address = '', phone = '', storageError = '';
  RangeValues priceRange = const RangeValues(1, 100);
  String filterItem = 'All';
  final Set<String> favorites = {};
  final List<CartLine> cart = [];
  final List<FoodOrder> orders = [];
  Food selectedFood = foods[1];
  int get count => cart.fold(0, (sum, line) => sum + line.quantity);
  int get subtotal => cart.fold(0, (sum, line) => sum + line.total);
  int get discount => promo ? (subtotal * .1).round() : 0;
  int get total => subtotal - discount;
  FoodOrder? get latestOrder => orders.isEmpty ? null : orders.first;

  Future<void> persist() async {
    notifyListeners();
    try {
      await repository.save({
        'dark': dark,
        'onboarded': onboarded,
        'name': name,
        'email': email,
        'address': address,
        'phone': phone,
        'favorites': favorites.toList(),
        'cart': cart.map((e) => e.toJson()).toList(),
        'orders': orders.map((e) => e.toJson()).toList(),
      });
      storageError = '';
    } catch (_) {
      storageError = 'Changes could not be saved. Please try again.';
      notifyListeners();
    }
  }

  void add(Food food, int quantity, String topping) {
    final existing = cart.where(
      (e) => e.food.id == food.id && e.topping == topping,
    );
    if (existing.isEmpty) {
      cart.add(
        CartLine(food, quantity: quantity.clamp(1, 99), topping: topping),
      );
    } else {
      existing.first.quantity = (existing.first.quantity + quantity).clamp(
        1,
        99,
      );
    }
    persist();
  }

  void changeQuantity(CartLine line, int delta) {
    line.quantity = (line.quantity + delta).clamp(0, 99);
    if (line.quantity == 0) cart.remove(line);
    if (cart.isEmpty) promo = false;
    persist();
  }

  void favorite(String id) {
    favorites.contains(id) ? favorites.remove(id) : favorites.add(id);
    persist();
  }

  FoodOrder? placeOrder() {
    if (cart.isEmpty) return null;
    final order = FoodOrder(
      id: DateTime.now().millisecondsSinceEpoch.toString().substring(6),
      total: total,
      count: count,
    );
    orders.insert(0, order);
    cart.clear();
    promo = false;
    persist();
    return order;
  }

  void receive() {
    latestOrder?.received = true;
    persist();
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
    : super(notifier: state);
  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
