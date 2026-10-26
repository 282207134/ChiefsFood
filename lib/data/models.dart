class Food {
  const Food(
    this.id,
    this.name,
    this.cents,
    this.image,
    this.category,
    this.description,
  );
  final String id, name, image, category, description;
  final int cents;
}

const foods = [
  Food(
    'noodles',
    'Spicy Cheese Noodles',
    790,
    'noodles',
    'Italian',
    'Freshly tossed spaghetti with soft cheese, basil leaves and a little kick of spice. Comfort food, made with love.',
  ),
  Food(
    'chicken',
    'Healthy Chicken with Salad',
    1256,
    'chicken',
    'Featured',
    'Grilled chicken, crisp seasonal greens, avocado and cherry tomatoes. Fresh, colourful and full of goodness.',
  ),
  Food(
    'salad',
    'Greek Salad',
    510,
    'salad',
    'Featured',
    'Crisp greens, juicy tomatoes, olives and creamy feta with our house lemon dressing.',
  ),
  Food(
    'tandoori',
    'Chicken Tandoori',
    2210,
    'tandoori',
    'Thai',
    'Tender chicken marinated in aromatic spices, grilled and served with fresh vegetables.',
  ),
  Food(
    'salmon',
    'Salmon Dish',
    2048,
    'salmon',
    'Featured',
    'Pan-seared salmon with seasonal vegetables and a bright herb dressing.',
  ),
  Food(
    'cola',
    'Coca-Cola Can',
    240,
    'cola',
    'Drinks',
    'An ice-cold classic. The perfect partner for your favourite meal.',
  ),
  Food(
    'fries',
    'Crispy French Fries',
    220,
    'fries',
    'Snacks',
    'Golden, crisp potato fries with a sprinkle of sea salt.',
  ),
];

String money(int cents) => '\$${(cents / 100).toStringAsFixed(2)}';

class CartLine {
  CartLine(this.food, {this.quantity = 1, this.topping = 'Pepper'});
  final Food food;
  int quantity;
  String topping;
  int get total => food.cents * quantity;
  Map<String, dynamic> toJson() => {
    'id': food.id,
    'quantity': quantity,
    'topping': topping,
  };
  static CartLine? fromJson(Map<String, dynamic> json) {
    final matches = foods.where((food) => food.id == json['id']);
    final quantity = json['quantity'];
    if (matches.isEmpty || quantity is! int || quantity < 1 || quantity > 99) {
      return null;
    }
    return CartLine(
      matches.first,
      quantity: quantity,
      topping: json['topping'] as String? ?? 'Pepper',
    );
  }
}

class FoodOrder {
  FoodOrder({
    required this.id,
    required this.total,
    required this.count,
    this.received = false,
  });
  final String id;
  final int total, count;
  bool received;
  Map<String, dynamic> toJson() => {
    'id': id,
    'total': total,
    'count': count,
    'received': received,
  };
  factory FoodOrder.fromJson(Map<String, dynamic> json) => FoodOrder(
    id: json['id'] as String,
    total: json['total'] as int,
    count: json['count'] as int,
    received: json['received'] as bool? ?? false,
  );
}
