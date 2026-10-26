import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../data/models.dart';
import '../../shared/widgets.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key, this.orders = false, this.history = false});
  final bool orders, history;
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late bool history = widget.history;
  final promo = TextEditingController();
  @override
  void dispose() {
    promo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return PageFrame(
      title: widget.orders ? 'My Cart' : 'Cart',
      tab: widget.orders ? 2 : null,
      bottom: widget.orders
          ? null
          : PrimaryButton(
              'Checkout · ${money(state.total)}',
              onPressed: state.cart.isEmpty
                  ? null
                  : () => go(context, '/checkout'),
              icon: Icons.arrow_forward,
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.orders) ...[
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF3A3A3A)
                    : const Color(0xFFECECEC),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                children: [
                  for (final entry in [(false, 'My Order'), (true, 'History')])
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(28),
                        onTap: () => setState(() => history = entry.$1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: history == entry.$1
                                ? orange
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Text(
                            entry.$2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: history == entry.$1 ? Colors.black : muted,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: orange,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const FoodImage('noodles', size: 90),
                  const SizedBox(width: 18),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Food Package',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'A little treat for your next meal.\nUse CHIEF10 for 10% off.',
                          style: TextStyle(color: Colors.white, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
          ],
          if (history) ...[
            const SectionTitle('Order history'),
            if (state.orders.isEmpty)
              _empty(
                context,
                'No orders yet',
                'Your delicious memories will appear here.',
              ),
            ...state.orders.map(
              (order) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Surface(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.shopping_bag_outlined,
                            color: orange,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Order #${order.id}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            money(order.total),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${order.count} items · ${order.received ? 'Delivered' : 'Preparing'} · Demo order',
                        style: const TextStyle(color: muted, fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () =>
                            go(context, order.received ? '/rate' : '/track'),
                        child: Text(
                          order.received
                              ? 'Rate your meal'
                              : 'Track latest order',
                          style: const TextStyle(color: orange),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ] else ...[
            if (widget.orders) SectionTitle('Your order (${state.count})'),
            if (state.cart.isEmpty)
              _empty(
                context,
                'Your cart is waiting',
                'Find something delicious to get started.',
              ),
            ...state.cart.map(
              (line) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Surface(
                  child: Row(
                    children: [
                      FoodImage(line.food.image, size: 72),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              line.food.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Topping: ${line.topping}',
                              style: const TextStyle(
                                color: muted,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 7),
                            Text(
                              money(line.total),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      QuantityControl(
                        value: line.quantity,
                        onMinus: () => state.changeQuantity(line, -1),
                        onPlus: () => state.changeQuantity(line, 1),
                        vertical: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (state.cart.isNotEmpty) ...[
              Surface(
                child: Column(
                  children: [
                    TextField(
                      controller: promo,
                      decoration: InputDecoration(
                        hintText: 'Add promo code',
                        suffixIcon: TextButton(
                          onPressed: () {
                            if (promo.text.trim().toUpperCase() != 'CHIEF10') {
                              message(
                                context,
                                'Use CHIEF10 for 10% off your demo order.',
                              );
                              return;
                            }
                            state.promo = true;
                            state.persist();
                            message(context, '10% discount applied.');
                          },
                          child: const Text(
                            'Apply',
                            style: TextStyle(color: orange),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    if (state.promo)
                      _summary(
                        'Discount · CHIEF10',
                        '-${money(state.discount)}',
                      ),
                    _summary('Total', money(state.total), large: true),
                  ],
                ),
              ),
              if (widget.orders) ...[
                const SizedBox(height: 24),
                PrimaryButton(
                  'Continue to checkout',
                  onPressed: () => go(context, '/checkout'),
                  icon: Icons.arrow_forward,
                ),
              ],
            ],
          ],
        ],
      ),
    );
  }

  Widget _empty(BuildContext context, String title, String subtitle) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 50),
    child: Center(
      child: Column(
        children: [
          const Icon(Icons.shopping_bag_outlined, size: 60, color: orange),
          const SizedBox(height: 20),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: muted, fontSize: 12),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () => go(context, '/menu'),
            child: const Text(
              'Explore the menu',
              style: TextStyle(color: orange),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _summary(String label, String value, {bool large = false}) => Padding(
  padding: const EdgeInsets.symmetric(vertical: 9),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Text(
          label,
          style: TextStyle(
            fontSize: large ? 20 : 13,
            color: large ? null : muted,
            fontWeight: large ? FontWeight.w500 : null,
          ),
        ),
      ),
      Text(
        value,
        style: TextStyle(
          fontSize: large ? 20 : 13,
          fontWeight: large ? FontWeight.w600 : null,
        ),
      ),
    ],
  ),
);

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});
  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final form = GlobalKey<FormState>();
  late TextEditingController address, phone;
  final city = TextEditingController(text: 'Toronto, Ontario');
  final zip = TextEditingController(text: 'M5V 3L9');
  @override
  void initState() {
    super.initState();
    address = TextEditingController();
    phone = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (address.text.isEmpty) {
      address.text = AppScope.of(context).address;
      phone.text = AppScope.of(context).phone;
    }
  }

  @override
  void dispose() {
    for (final c in [address, phone, city, zip]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return PageFrame(
      title: 'Checkout',
      bottom: PrimaryButton(
        'Continue to payment',
        onPressed: state.cart.isEmpty
            ? null
            : () {
                if (!form.currentState!.validate()) return;
                state.address = address.text.trim();
                state.phone = phone.text.trim();
                state.persist();
                go(context, '/payment');
              },
        icon: Icons.arrow_forward,
      ),
      child: Form(
        key: form,
        child: Surface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Total amount',
                      style: TextStyle(color: muted, fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${money(state.total)} USD',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Fresh food is one step closer.',
                      style: TextStyle(color: muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              LabeledField(
                'Delivery place',
                controller: address,
                validator: requiredField,
              ),
              LabeledField('City', controller: city, validator: requiredField),
              LabeledField(
                'Phone',
                controller: phone,
                type: TextInputType.phone,
                validator: (value) =>
                    RegExp(r'^\+?[\d\s()-]{7,20}$').hasMatch(value ?? '')
                    ? null
                    : 'Enter a valid phone number',
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: LabeledField(
                      'Country',
                      initialValue: 'Canada',
                      validator: requiredField,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: LabeledField(
                      'Zip code',
                      controller: zip,
                      validator: requiredField,
                    ),
                  ),
                ],
              ),
              const Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: orange),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Local demo · No delivery will be booked.',
                      style: TextStyle(color: muted, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool confirming = false;
  DateTime? schedule;
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return PageFrame(
      title: 'Payment',
      bottom: PrimaryButton(
        'Confirm demo order · ${money(state.total)}',
        onPressed: confirming || state.cart.isEmpty
            ? null
            : () {
                setState(() => confirming = true);
                if (state.placeOrder() != null) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/confirm',
                    (_) => false,
                  );
                } else {
                  setState(() => confirming = false);
                }
              },
        icon: Icons.check,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Surface(
            child: Row(
              children: [
                Icon(Icons.shield_outlined, color: orange),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Demo checkout\nNo real payment or card details required.',
                    style: TextStyle(fontSize: 12, color: muted),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF242424),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.credit_card, color: orange, size: 30),
                    Text(
                      'DEMO CARD',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 2,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  '••••   ••••   ••••   4242',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  state.name.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Surface(
            child: Column(
              children: [
                _summary('Subtotal', money(state.subtotal)),
                if (state.promo)
                  _summary('Discount', '-${money(state.discount)}'),
                _summary('Delivery charge', money(0)),
                _summary('VAT', money(0)),
                const Divider(),
                _summary('Total', money(state.total), large: true),
              ],
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 7)),
              );
              if (date != null && mounted) setState(() => schedule = date);
            },
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: muted,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    schedule == null
                        ? 'Add delivery schedule (optional)'
                        : '${schedule!.year}-${schedule!.month}-${schedule!.day} · Demo only',
                    style: const TextStyle(color: muted, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TrackPage extends StatelessWidget {
  const TrackPage({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return PageFrame(
      title: 'Track order',
      padding: false,
      bottom: PrimaryButton(
        'Mark demo order as received',
        orangeStyle: true,
        onPressed: state.latestOrder == null
            ? null
            : () {
                state.receive();
                Navigator.pushReplacementNamed(context, '/received');
              },
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: DeliveryMapPainter(dark: state.dark)),
          ),
          const Positioned(
            top: 24,
            left: 20,
            child: Chip(
              avatar: Icon(Icons.info_outline, size: 16),
              label: Text(
                'Simulated route · No live GPS',
                style: TextStyle(fontSize: 10),
              ),
            ),
          ),
          const Positioned(
            top: 140,
            left: 90,
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: orange,
                  radius: 26,
                  child: Icon(Icons.location_on_outlined, color: Colors.black),
                ),
                SizedBox(height: 8),
                Text(
                  '20 min',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const Positioned(
            top: 310,
            right: 44,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 34,
              child: FoodImage('chicken', size: 62),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Surface(
                padding: EdgeInsets.zero,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Delivery place',
                                  style: TextStyle(color: muted, fontSize: 11),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  state.address,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Column(
                            children: [
                              Text(
                                'Arrives in',
                                style: TextStyle(color: muted, fontSize: 11),
                              ),
                              SizedBox(height: 6),
                              Text('20 min', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: orange,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(14),
                        ),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Color(0xFFFFD783),
                            child: Icon(
                              Icons.delivery_dining,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Delivery partner · Demo',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  'Nicholas Fabiano',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: 'Demo delivery information',
                            onPressed: () => message(
                              context,
                              'This is a simulated delivery. No courier has been contacted.',
                            ),
                            icon: const Icon(
                              Icons.chat_bubble_outline,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DeliveryMapPainter extends CustomPainter {
  DeliveryMapPainter({required this.dark});
  final bool dark;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(
      dark ? const Color(0xFF292929) : const Color(0xFFF1F1F1),
      BlendMode.src,
    );
    final road = Paint()
      ..color = dark ? const Color(0xFF373737) : Colors.white
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke;
    for (var i = -2; i < 9; i++) {
      canvas.drawLine(
        Offset(i * 88.0, -20),
        Offset(i * 88.0 - 240, size.height + 20),
        road,
      );
      canvas.drawLine(
        Offset(-20, i * 104.0),
        Offset(size.width + 20, i * 104.0 + 100),
        road,
      );
    }
    final route = Path()
      ..moveTo(116, 168)
      ..lineTo(105, 255)
      ..lineTo(145, 267)
      ..lineTo(141, 290)
      ..lineTo(size.width - 76, 335);
    canvas.drawPath(
      route,
      Paint()
        ..color = Colors.white
        ..strokeWidth = 9
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawPath(
      route,
      Paint()
        ..color = orange
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(DeliveryMapPainter oldDelegate) =>
      dark != oldDelegate.dark;
}

class ReceivedPage extends StatelessWidget {
  const ReceivedPage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Order received',
    bottom: TextButton(
      onPressed: () => home(context),
      child: const Text('Skip', style: TextStyle(color: muted)),
    ),
    child: Column(
      children: [
        const SizedBox(height: 20),
        Text(
          'You received the order!',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 28),
        Surface(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              const Icon(Icons.card_giftcard_rounded, size: 135, color: orange),
              const SizedBox(height: 24),
              Text(
                'Order #${AppScope.of(context).latestOrder?.id ?? '456723'}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
        const SizedBox(height: 36),
        const Text('How do you feel about your food?'),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (final item in [
              ('Sad', Icons.sentiment_dissatisfied),
              ('Good!', Icons.sentiment_satisfied),
              ('Amazing', Icons.sentiment_very_satisfied),
            ])
              InkWell(
                onTap: () => Navigator.pushNamed(
                  context,
                  '/rate',
                  arguments: item.$1 == 'Sad'
                      ? 2
                      : item.$1 == 'Good!'
                      ? 4
                      : 5,
                ),
                borderRadius: BorderRadius.circular(40),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color(0xFFFFF0D6),
                      child: Icon(item.$2, size: 38, color: orange),
                    ),
                    const SizedBox(height: 12),
                    Text(item.$1, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
          ],
        ),
      ],
    ),
  );
}

class RatePage extends StatefulWidget {
  const RatePage({super.key});
  @override
  State<RatePage> createState() => _RatePageState();
}

class _RatePageState extends State<RatePage> {
  int rating = 5;
  bool initialized = false;
  final controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!initialized) {
      rating = ModalRoute.of(context)?.settings.arguments as int? ?? 5;
      initialized = true;
    }
    return PageFrame(
      title: 'Rate shop',
      bottom: PrimaryButton(
        'Send feedback',
        onPressed: () => Navigator.pushReplacementNamed(context, '/feedback'),
      ),
      child: Surface(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const CircleAvatar(
              radius: 48,
              backgroundColor: orange,
              child: Icon(Icons.restaurant, size: 46, color: Colors.white),
            ),
            const SizedBox(height: 24),
            Text(
              'Chief’s Restaurant',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            const Text(
              'Toronto, Ontario, Canada',
              style: TextStyle(color: muted),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFF2DB),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  5,
                  (i) => IconButton(
                    tooltip: 'Rate ${i + 1} stars',
                    onPressed: () => setState(() => rating = i + 1),
                    icon: Icon(
                      i < rating ? Icons.star : Icons.star_border,
                      color: orange,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Message', style: TextStyle(color: muted)),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              maxLines: 6,
              maxLength: 500,
              decoration: const InputDecoration(
                hintText: 'Tell us about your meal…',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Feedback is demonstrated locally.',
              style: TextStyle(color: muted, fontSize: 11),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
