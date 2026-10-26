import 'package:flutter/material.dart';

import 'core/app_state.dart';
import 'core/theme.dart';
import 'features/auth/auth_pages.dart';
import 'features/discover/discover_pages.dart';
import 'features/orders/order_pages.dart';
import 'features/profile/profile_pages.dart';
import 'shared/widgets.dart';

final appRoutes = <String, WidgetBuilder>{
  '/splash': (_) => const SplashPage(),
  '/onboarding': (_) => const OnboardingPage(),
  '/onboarding-2': (_) => const OnboardingPage(initialIndex: 1),
  '/onboarding-3': (_) => const OnboardingPage(initialIndex: 2),
  '/login': (_) => const AuthPage(mode: 'login'),
  '/signup': (_) => const AuthPage(mode: 'signup'),
  '/forgot': (_) => const AuthPage(mode: 'forgot'),
  '/recovery': (_) => const RecoveryPage(),
  '/verify': (_) => const VerifyPage(),
  '/reset': (_) => const AuthPage(mode: 'reset'),
  '/reset-success': (_) => const SuccessPage(kind: 'reset'),
  '/location': (_) => const LocationPage(),
  '/home': (_) => const HomePage(),
  '/menu': (_) => const MenuPage(),
  '/detail': (_) => const DetailPage(),
  '/search': (_) => const SearchPage(),
  '/filter': (_) => const FilterPage(),
  '/cart': (_) => const CartPage(),
  '/orders': (_) => const CartPage(orders: true),
  '/history': (_) => const CartPage(orders: true, history: true),
  '/checkout': (_) => const CheckoutPage(),
  '/payment': (_) => const PaymentPage(),
  '/confirm': (_) => const SuccessPage(kind: 'order'),
  '/track': (_) => const TrackPage(),
  '/received': (_) => const ReceivedPage(),
  '/rate': (_) => const RatePage(),
  '/feedback': (_) => const SuccessPage(kind: 'feedback'),
  '/profile': (_) => const ProfilePage(),
  '/personal': (_) => const PersonalPage(),
  '/saved': (_) => const MenuPage(saved: true),
  '/settings': (_) => const SettingsPage(),
  '/security': (_) => const InfoPage(kind: 'security'),
  '/permissions': (_) => const InfoPage(kind: 'permissions'),
  '/notifications': (_) => const InfoPage(kind: 'notifications'),
  '/methods': (_) => const MethodsPage(),
  '/scan': (_) => const ScanPage(),
  '/scan-success': (_) => const ScanSuccessPage(),
};

class ChiefsFoodApp extends StatelessWidget {
  const ChiefsFoodApp({
    super.key,
    required this.state,
    this.initialRoute,
    this.navigatorKey,
  });
  final AppState state;
  final String? initialRoute;
  final GlobalKey<NavigatorState>? navigatorKey;
  @override
  Widget build(BuildContext context) => AppScope(
    state: state,
    child: AnimatedBuilder(
      animation: state,
      builder: (context, _) => MaterialApp(
        title: 'Chief’s Food',
        debugShowCheckedModeBanner: false,
        theme: appTheme(false),
        darkTheme: appTheme(true),
        themeMode: state.dark ? ThemeMode.dark : ThemeMode.light,
        navigatorKey: navigatorKey,
        initialRoute: initialRoute ?? (state.onboarded ? '/home' : '/splash'),
        routes: appRoutes,
        builder: (context, child) => ColoredBox(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1C1C1C)
              : const Color(0xFFF1F1F1),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: child,
            ),
          ),
        ),
      ),
    ),
  );
}

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(28),
              decoration: const BoxDecoration(
                color: orange,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.restaurant_rounded,
                color: Colors.white,
                size: 72,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'CHIEF’S',
              style: TextStyle(
                fontSize: 38,
                letterSpacing: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'GOOD FOOD. GOOD MOOD.',
              style: TextStyle(color: muted, fontSize: 11, letterSpacing: 2),
            ),
            const Spacer(),
            PrimaryButton(
              'Let’s eat',
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/onboarding'),
              icon: Icons.arrow_forward,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );
}
