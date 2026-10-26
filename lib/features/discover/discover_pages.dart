import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../data/models.dart';
import '../../shared/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  String category = 'Fast Foods';
  @override
  Widget build(BuildContext context) {
    final specials = [foods[0], foods[1], foods[4]];
    final food = specials[index];
    return PageFrame(
      title: "Today's Special",
      tab: 0,
      back: false,
      search: true,
      bottom: PrimaryButton(
        'Buy at ${money(food.cents)}',
        onPressed: () {
          AppScope.of(context).selectedFood = food;
          go(context, '/detail');
        },
        icon: Icons.arrow_forward,
      ),
      child: Column(
        children: [
          const SizedBox(height: 4),
          Text(
            food.name.replaceFirst(' ', '\n'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 12),
          const Text(
            'Fresh ingredients. A little happiness.',
            style: TextStyle(color: muted, fontSize: 12),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final size = constraints.maxWidth.clamp(
                0.0,
                MediaQuery.sizeOf(context).height * .30,
              );
              return SizedBox(
                height: size + 12,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: size - 8,
                      height: size - 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF343434)
                            : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .07),
                            blurRadius: 40,
                            offset: const Offset(0, 24),
                          ),
                        ],
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: FoodImage(
                        food.image,
                        key: ValueKey(food.id),
                        size: size - 46,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton.filledTonal(
                        tooltip: 'Previous special',
                        onPressed: () =>
                            setState(() => index = (index + 2) % 3),
                        icon: const Icon(Icons.chevron_left),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton.filled(
                        tooltip: 'Next special',
                        style: IconButton.styleFrom(
                          backgroundColor: orange,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () =>
                            setState(() => index = (index + 1) % 3),
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ),
                    const Positioned(
                      top: 8,
                      left: 18,
                      child: Text(
                        '+',
                        style: TextStyle(
                          fontSize: 28,
                          color: Color(0xFFDDDDDD),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          ChoicePills(
            items: const ['Sea Foods', 'Fast Foods', 'Snacks'],
            value: category,
            onChanged: (value) => setState(() {
              category = value;
              index = value == 'Sea Foods'
                  ? 2
                  : value == 'Fast Foods'
                  ? 0
                  : 1;
            }),
          ),
        ],
      ),
    );
  }
}

class MenuPage extends StatefulWidget {
  const MenuPage({super.key, this.saved = false});
  final bool saved;
  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String category = 'Featured';
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final list = foods
        .where(
          (e) => widget.saved
              ? state.favorites.contains(e.id)
              : category == 'All' ||
                    (category == 'Featured'
                        ? [
                            'chicken',
                            'salad',
                            'tandoori',
                            'salmon',
                          ].contains(e.id)
                        : e.category == category),
        )
        .toList();
    return PageFrame(
      title: widget.saved ? 'Saved favourites' : 'Menu',
      tab: widget.saved ? null : 1,
      child: Column(
        children: [
          TextField(
            readOnly: true,
            onTap: () => go(context, '/search'),
            decoration: const InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search, color: Color(0xFFCCCCCC)),
            ),
          ),
          const SizedBox(height: 24),
          if (!widget.saved)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    ['All', 'Featured', 'Thai', 'Italian', 'Drinks', 'Snacks']
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: InkWell(
                              onTap: () => setState(() => category = e),
                              child: Column(
                                children: [
                                  Text(
                                    e,
                                    style: TextStyle(
                                      fontSize: e == category ? 18 : 12,
                                      fontWeight: e == category
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: e == category
                                          ? Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                          : muted,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    width: 22,
                                    height: 2,
                                    color: e == category
                                        ? orange
                                        : Colors.transparent,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
          const SizedBox(height: 24),
          if (list.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 90),
              child: Column(
                children: [
                  Icon(Icons.favorite_border, size: 52, color: orange),
                  SizedBox(height: 16),
                  Text('Your favourites will live here.'),
                  SizedBox(height: 8),
                  Text(
                    'Tap a heart on any meal to save it.',
                    style: TextStyle(color: muted, fontSize: 12),
                  ),
                ],
              ),
            ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 230,
              mainAxisExtent: 212,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (_, i) => FoodCard(list[i]),
          ),
        ],
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int quantity = 1;
  String topping = 'Pepper';
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final food = state.selectedFood;
    return PageFrame(
      title: 'Your meal',
      bottom: PrimaryButton(
        'Add to cart · ${money(food.cents * quantity)}',
        orangeStyle: true,
        onPressed: () {
          state.add(food, quantity, topping);
          go(context, '/cart');
        },
        icon: Icons.shopping_bag_outlined,
      ),
      child: Column(
        children: [
          Text(
            food.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            money(food.cents),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 24),
          FoodImage(food.image, size: 250),
          const SizedBox(height: 12),
          QuantityControl(
            value: quantity,
            onMinus: () => setState(() {
              if (quantity > 1) quantity--;
            }),
            onPlus: () => setState(() => quantity++),
          ),
          const SizedBox(height: 24),
          Surface(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle('Description'),
                Text(
                  food.description,
                  style: const TextStyle(color: muted, fontSize: 13),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Add extra topping',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                ChoicePills(
                  items: const ['Pepper', 'Tomato', 'Mayo'],
                  value: topping,
                  onChanged: (value) => setState(() => topping = value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final query = controller.text.trim().toLowerCase();
    final matches = foods
        .where(
          (e) =>
              e.name.toLowerCase().contains(query) &&
              e.cents >= state.priceRange.start * 100 &&
              e.cents <= state.priceRange.end * 100 &&
              (state.filterItem == 'All' || e.category == state.filterItem),
        )
        .toList();
    return PageFrame(
      title: 'Search',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Find something delicious',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      tooltip: 'Clear search',
                      onPressed: () => setState(controller.clear),
                      icon: const Icon(Icons.cancel, color: muted, size: 20),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton.outlined(
                tooltip: 'Filter results',
                onPressed: () async {
                  await Navigator.pushNamed(context, '/filter');
                  if (mounted) setState(() {});
                },
                icon: const Icon(Icons.tune),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (query.isEmpty) ...[
            const SectionTitle('Popular searches'),
            ChoicePills(
              items: const ['Chicken', 'Salad', 'Noodles'],
              value: '',
              onChanged: (value) => setState(() => controller.text = value),
            ),
            const SizedBox(height: 28),
          ],
          SectionTitle(
            query.isEmpty ? 'Made for you' : '${matches.length} results',
          ),
          if (matches.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 70),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.search_off, size: 56, color: muted),
                    SizedBox(height: 16),
                    Text('No meals found'),
                    Text(
                      'Try another search or clear the filters.',
                      style: TextStyle(color: muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ...matches.map(
            (food) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: InkWell(
                onTap: () {
                  state.selectedFood = food;
                  go(context, '/detail');
                },
                child: Surface(
                  child: Row(
                    children: [
                      FoodImage(food.image, size: 94),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              food.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              food.category,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              money(food.cents),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
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
          ),
        ],
      ),
    );
  }
}

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});
  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  RangeValues? range;
  String? item;
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    range ??= state.priceRange;
    item ??= state.filterItem;
    return PageFrame(
      title: 'Filter',
      bottom: PrimaryButton(
        'Apply filters',
        orangeStyle: true,
        onPressed: () {
          state.priceRange = range!;
          state.filterItem = item!;
          Navigator.pop(context);
        },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Type'),
          const ChoiceChip(
            label: Text('Menu'),
            selected: true,
            selectedColor: orange,
            showCheckmark: false,
          ),
          const SizedBox(height: 30),
          const SectionTitle('Cuisine & category'),
          ChoicePills(
            items: const [
              'All',
              'Featured',
              'Thai',
              'Italian',
              'Drinks',
              'Snacks',
            ],
            value: item!,
            onChanged: (value) => setState(() => item = value),
          ),
          const SizedBox(height: 34),
          SectionTitle(
            'Price range',
            trailing: Text(
              '\$${range!.start.round()}–\$${range!.end.round()}',
              style: const TextStyle(color: orange, fontSize: 12),
            ),
          ),
          RangeSlider(
            values: range!,
            min: 1,
            max: 100,
            divisions: 99,
            onChanged: (value) => setState(() => range = value),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('\$1'), Text('\$100')],
          ),
          const SizedBox(height: 48),
          Center(
            child: TextButton(
              onPressed: () => setState(() {
                range = const RangeValues(1, 100);
                item = 'All';
              }),
              child: Text(
                'Clear filters',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
