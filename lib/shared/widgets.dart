import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../core/theme.dart';
import '../data/models.dart';

void go(BuildContext context, String route) =>
    Navigator.pushNamed(context, route);
void home(BuildContext context) =>
    Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
void message(BuildContext context, String text) => ScaffoldMessenger.of(context)
    .showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );

class PageFrame extends StatelessWidget {
  const PageFrame({
    super.key,
    required this.title,
    required this.child,
    this.bottom,
    this.tab,
    this.back = true,
    this.padding = true,
    this.search = false,
  });
  final String title;
  final Widget child;
  final Widget? bottom;
  final int? tab;
  final bool back, padding;
  final bool search;
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: back ? 'Back' : 'Open profile',
          icon: Icon(back ? Icons.chevron_left : Icons.menu_rounded, size: 26),
          onPressed: () {
            if (back && Navigator.canPop(context)) {
              Navigator.pop(context);
            } else if (back) {
              home(context);
            } else {
              go(context, '/profile');
            }
          },
        ),
        title: Text(title),
        actions: [
          if (search)
            IconButton(
              tooltip: 'Search meals',
              onPressed: () => go(context, '/search'),
              icon: const Icon(Icons.search),
            ),
          IconButton(
            tooltip: 'Notifications',
            onPressed: () => go(context, '/notifications'),
            icon: Badge(
              smallSize: 6,
              backgroundColor: orange,
              child: const Icon(Icons.notifications_none_rounded),
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            if (state.storageError.isNotEmpty)
              MaterialBanner(
                content: Text(state.storageError),
                actions: [
                  TextButton(
                    onPressed: state.persist,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            Expanded(
              child: padding
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                      child: child,
                    )
                  : child,
            ),
          ],
        ),
      ),
      bottomNavigationBar: tab != null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (bottom != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                    child: bottom!,
                  ),
                FoodNavigation(index: tab!),
              ],
            )
          : bottom == null
          ? null
          : SafeArea(
              top: false,
              minimum: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: bottom!,
            ),
    );
  }
}

class FoodNavigation extends StatelessWidget {
  const FoodNavigation({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    final count = AppScope.of(context).count;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF303030)
            : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .025),
            blurRadius: 30,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(4, (i) {
              const icons = [
                Icons.home_outlined,
                Icons.restaurant_menu_rounded,
                Icons.shopping_cart_outlined,
                Icons.person_outline_rounded,
              ];
              const labels = ['Home', 'Menu', 'My cart', 'Profile'];
              return Semantics(
                selected: i == index,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    if (i != index) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        ['/home', '/menu', '/orders', '/profile'][i],
                        (_) => false,
                      );
                    }
                  },
                  child: SizedBox(
                    width: 66,
                    height: 48,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Badge(
                          isLabelVisible: i == 2 && count > 0,
                          label: Text('$count'),
                          backgroundColor: orange,
                          textColor: Colors.black,
                          child: Icon(
                            icons[i],
                            color: i == index
                                ? Theme.of(context).colorScheme.onSurface
                                : const Color(0xFFA9B2BE),
                            size: 25,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          labels[i],
                          style: TextStyle(
                            fontSize: 9,
                            color: i == index ? orange : muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
    this.label, {
    super.key,
    required this.onPressed,
    this.orangeStyle = false,
    this.icon,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool orangeStyle;
  final IconData? icon;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 50,
    child: FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: orangeStyle ? orange : const Color(0xFF161616),
        foregroundColor: orangeStyle ? Colors.black : Colors.white,
        disabledBackgroundColor: const Color(0xFFDDDDDD),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          if (icon != null) ...[
            const SizedBox(width: 12),
            Icon(icon, size: 18),
          ],
        ],
      ),
    ),
  );
}

class Surface extends StatelessWidget {
  const Surface({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });
  final Widget child;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .035),
          blurRadius: 32,
          offset: const Offset(0, 16),
        ),
      ],
    ),
    child: Material(
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF303030)
          : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: Padding(padding: padding, child: child),
    ),
  );
}

class FoodImage extends StatelessWidget {
  const FoodImage(this.name, {super.key, this.size = 100});
  final String name;
  final double size;
  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/images/$name.png',
    width: size,
    height: size,
    fit: BoxFit.contain,
    gaplessPlayback: true,
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.trailing});
  final String text;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.titleLarge),
        ),
        ?trailing,
      ],
    ),
  );
}

class LabeledField extends StatelessWidget {
  const LabeledField(
    this.label, {
    super.key,
    this.controller,
    this.initialValue,
    this.validator,
    this.obscure = false,
    this.type,
    this.suffix,
    this.maxLines = 1,
    this.onChanged,
  });
  final String label;
  final String? initialValue;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscure;
  final TextInputType? type;
  final Widget? suffix;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: muted)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          validator: validator,
          obscureText: obscure,
          keyboardType: type,
          maxLines: maxLines,
          onChanged: onChanged,
          decoration: InputDecoration(hintText: label, suffixIcon: suffix),
        ),
      ],
    ),
  );
}

String? requiredField(String? value) =>
    value == null || value.trim().isEmpty ? 'Please complete this field' : null;
String? emailField(String? value) =>
    RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value?.trim() ?? '')
    ? null
    : 'Enter a valid email address';

class ChoicePills extends StatelessWidget {
  const ChoicePills({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
  });
  final List<String> items;
  final String value;
  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 12,
    runSpacing: 12,
    children: items
        .map(
          (e) => ChoiceChip(
            label: Text(e),
            selected: e == value,
            showCheckmark: false,
            selectedColor: orange,
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF3C3C3C)
                : const Color(0xFFEDEDED),
            side: BorderSide.none,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            labelStyle: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: e == value ? Colors.black : muted,
            ),
            onSelected: (_) => onChanged(e),
          ),
        )
        .toList(),
  );
}

class QuantityControl extends StatelessWidget {
  const QuantityControl({
    super.key,
    required this.value,
    required this.onMinus,
    required this.onPlus,
    this.vertical = false,
  });
  final int value;
  final VoidCallback onMinus, onPlus;
  final bool vertical;
  @override
  Widget build(BuildContext context) {
    final items = [
      IconButton.filledTonal(
        tooltip: value == 1 ? 'Remove item' : 'Decrease quantity',
        style: IconButton.styleFrom(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF444444)
              : const Color(0xFFEDEDED),
          minimumSize: const Size(32, 32),
          maximumSize: const Size(32, 32),
          padding: EdgeInsets.zero,
        ),
        onPressed: onMinus,
        icon: const Icon(Icons.remove, size: 16, color: muted),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
        child: Text(
          '$value',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      IconButton.filled(
        tooltip: 'Increase quantity',
        style: IconButton.styleFrom(
          backgroundColor: orange,
          foregroundColor: Colors.black,
          minimumSize: const Size(32, 32),
          maximumSize: const Size(32, 32),
          padding: EdgeInsets.zero,
        ),
        onPressed: value < 99 ? onPlus : null,
        icon: const Icon(Icons.add, size: 16),
      ),
    ];
    return vertical
        ? Column(mainAxisSize: MainAxisSize.min, children: items)
        : Row(mainAxisSize: MainAxisSize.min, children: items);
  }
}

class FoodCard extends StatelessWidget {
  const FoodCard(this.food, {super.key});
  final Food food;
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        state.selectedFood = food;
        go(context, '/detail');
      },
      child: Surface(
        padding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FoodImage(food.image, size: 108),
                const SizedBox(height: 10),
                Text(
                  food.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: muted, fontSize: 13),
                ),
                const SizedBox(height: 9),
                Text(
                  money(food.cents),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Positioned(
              top: -8,
              right: -8,
              child: IconButton(
                tooltip: 'Save ${food.name}',
                onPressed: () => state.favorite(food.id),
                icon: Icon(
                  state.favorites.contains(food.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: const Color(0xFFFF565B),
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
