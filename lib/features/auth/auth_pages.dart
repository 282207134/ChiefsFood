import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../shared/widgets.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key, this.initialIndex = 0});
  final int initialIndex;
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late int index = widget.initialIndex;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: LayoutBuilder(
          builder: (context, size) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: size.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => go(context, '/login'),
                      child: const Text(
                        'Skip',
                        style: TextStyle(color: Color(0xFF00A9F4)),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(90),
                      bottomRight: Radius.circular(90),
                      topRight: Radius.circular(24),
                      bottomLeft: Radius.circular(24),
                    ),
                    child: Image.asset(
                      'assets/images/onboarding.png',
                      width: 270,
                      height: size.maxHeight * .49,
                      fit: BoxFit.cover,
                      alignment: index == 0
                          ? Alignment.center
                          : index == 1
                          ? Alignment.topCenter
                          : Alignment.bottomCenter,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        Text(
                          [
                            'Choose your\nfavourite food',
                            'Freshly prepared,\njust for you',
                            'Good food,\nat your doorstep',
                          ][index],
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          [
                            'Discover meals you will love, made with\nthe freshest ingredients.',
                            'A little care in every meal.\nA lot of flavour in every bite.',
                            'Your next delicious moment\nis only a few taps away.',
                          ][index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: muted, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: index == i ? 28 : 10,
                        height: 4,
                        decoration: BoxDecoration(
                          color: index == i ? orange : const Color(0xFFE1E1E1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 28, bottom: 18),
                    child: PrimaryButton(
                      index == 2 ? 'Get started' : 'Next',
                      onPressed: () {
                        if (index < 2) {
                          setState(() => index++);
                        } else {
                          go(context, '/login');
                        }
                      },
                      icon: Icons.arrow_forward,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key, required this.mode});
  final String mode;
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final form = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  final confirmation = TextEditingController();
  bool hidden = true;
  bool get signup => widget.mode == 'signup';
  bool get reset => widget.mode == 'reset';
  bool get forgot => widget.mode == 'forgot';
  @override
  void dispose() {
    for (final c in [email, password, name, confirmation]) {
      c.dispose();
    }
    super.dispose();
  }

  void submit() {
    if (!form.currentState!.validate()) return;
    final state = AppScope.of(context);
    if (forgot) {
      go(context, '/recovery');
      return;
    }
    if (reset) {
      go(context, '/reset-success');
      return;
    }
    if (signup) {
      state.name = name.text.trim();
      state.email = email.text.trim();
      state.persist();
      go(context, '/verify');
    } else {
      if (email.text.isNotEmpty) state.email = email.text.trim();
      state.persist();
      go(context, '/location');
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = signup
        ? 'Sign up'
        : reset
        ? 'Reset password'
        : forgot
        ? 'Forgot password?'
        : 'Login';
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 32, 32, 24),
          child: Form(
            key: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "CHIEF’S",
                      style: TextStyle(
                        letterSpacing: 5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Back',
                      onPressed: () {
                        if (Navigator.canPop(context)) Navigator.pop(context);
                      },
                      icon: Icon(
                        forgot || reset ? Icons.lock_reset : Icons.lock_outline,
                        size: 36,
                        color: const Color(0xFFDEDEDE),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 36),
                Text(title, style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 12),
                Text(
                  signup
                      ? 'A delicious new beginning.'
                      : reset
                      ? 'Make your new password a strong one.'
                      : forgot
                      ? 'We will help you get back to your favourites.'
                      : 'Hi, welcome back to Chief’s.',
                  style: const TextStyle(color: muted),
                ),
                const SizedBox(height: 36),
                if (signup)
                  LabeledField(
                    'Your name',
                    controller: name,
                    validator: requiredField,
                  ),
                if (!reset)
                  LabeledField(
                    'Email address',
                    controller: email,
                    validator: emailField,
                    type: TextInputType.emailAddress,
                  ),
                if (!forgot)
                  LabeledField(
                    reset ? 'New password' : 'Password',
                    controller: password,
                    obscure: hidden,
                    validator: (value) => (value?.length ?? 0) < 6
                        ? 'Use at least 6 characters'
                        : null,
                    suffix: IconButton(
                      tooltip: hidden ? 'Show password' : 'Hide password',
                      onPressed: () => setState(() => hidden = !hidden),
                      icon: Icon(
                        hidden
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                        color: muted,
                      ),
                    ),
                  ),
                if (reset)
                  LabeledField(
                    'Confirm password',
                    controller: confirmation,
                    obscure: hidden,
                    validator: (value) => value != password.text
                        ? 'Passwords do not match'
                        : requiredField(value),
                  ),
                if (!signup && !forgot && !reset)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => go(context, '/forgot'),
                      child: const Text(
                        'Forgot?',
                        style: TextStyle(color: Color(0xFF00A9F4)),
                      ),
                    ),
                  ),
                const SizedBox(height: 28),
                PrimaryButton(
                  signup
                      ? 'Create account'
                      : forgot
                      ? 'Continue'
                      : reset
                      ? 'Reset password'
                      : 'Login',
                  onPressed: submit,
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'LOCAL DEMO · No real account is created',
                    style: TextStyle(
                      color: muted,
                      fontSize: 10,
                      letterSpacing: .4,
                    ),
                  ),
                ),
                if (!forgot && !reset) ...[
                  const SizedBox(height: 36),
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('or', style: TextStyle(color: muted)),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    'Try the demo',
                    orangeStyle: true,
                    onPressed: () => go(context, '/location'),
                    icon: Icons.arrow_forward,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () =>
                          go(context, signup ? '/login' : '/signup'),
                      child: Text(
                        signup
                            ? 'Already have an account? Login'
                            : 'Don’t have an account? Sign up',
                        style: const TextStyle(color: muted, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RecoveryPage extends StatelessWidget {
  const RecoveryPage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Password recovery',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 28),
        const Icon(Icons.lock_reset, size: 66, color: orange),
        const SizedBox(height: 28),
        Text(
          'Let’s get you back in.',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        const Text(
          'Choose how you would like to verify your identity.',
          style: TextStyle(color: muted),
        ),
        const SizedBox(height: 32),
        ...[
          ('Email verification', Icons.email_outlined),
          ('Phone verification', Icons.phone_outlined),
        ].map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Surface(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(e.$2, color: orange),
                title: Text(e.$1),
                subtitle: const Text(
                  'Demo code: 1234',
                  style: TextStyle(color: muted, fontSize: 12),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    Navigator.pushNamed(context, '/verify', arguments: 'reset'),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'This is a local demonstration. No email or SMS is sent.',
          style: TextStyle(color: muted, fontSize: 12),
        ),
      ],
    ),
  );
}

class VerifyPage extends StatefulWidget {
  const VerifyPage({super.key});
  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final controller = TextEditingController();
  String? error;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Verify your account',
    bottom: PrimaryButton(
      'Verify & continue',
      onPressed: () {
        if (controller.text != '1234') {
          setState(() => error = 'Use the demo code 1234');
          return;
        }
        go(
          context,
          ModalRoute.of(context)?.settings.arguments == 'reset'
              ? '/reset'
              : '/location',
        );
      },
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 36),
        const Icon(Icons.mark_email_read_outlined, size: 64, color: orange),
        const SizedBox(height: 32),
        Text(
          'A little security check.',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        const Text(
          'Enter the four-digit code to continue.\nFor this local demo, use 1234.',
          style: TextStyle(color: muted),
        ),
        const SizedBox(height: 40),
        TextField(
          controller: controller,
          maxLength: 4,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 32, letterSpacing: 20),
          decoration: InputDecoration(
            hintText: '0000',
            errorText: error,
            counterText: '',
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: TextButton(
            onPressed: () => message(
              context,
              'Your local demo code is 1234. No message was sent.',
            ),
            child: const Text('Resend code', style: TextStyle(color: orange)),
          ),
        ),
      ],
    ),
  );
}

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});
  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final form = GlobalKey<FormState>();
  final controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    controller.text = '143 New Star Building, Ontario';
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Delivery location',
    bottom: PrimaryButton(
      'Start exploring',
      orangeStyle: true,
      onPressed: () {
        if (!form.currentState!.validate()) return;
        final state = AppScope.of(context);
        state.address = controller.text.trim();
        state.onboarded = true;
        state.persist();
        home(context);
      },
    ),
    child: Form(
      key: form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 38),
          Center(
            child: Container(
              padding: const EdgeInsets.all(40),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF0D6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on_outlined,
                size: 80,
                color: orange,
              ),
            ),
          ),
          const SizedBox(height: 44),
          Text(
            'Where should we\nbring the goodness?',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),
          const Text(
            'Set your delivery address to get started.',
            style: TextStyle(color: muted),
          ),
          const SizedBox(height: 30),
          LabeledField(
            'Delivery address',
            controller: controller,
            validator: requiredField,
          ),
          const Text(
            'Address is entered manually in this demo.',
            style: TextStyle(fontSize: 12, color: muted),
          ),
        ],
      ),
    ),
  );
}

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key, required this.kind});
  final String kind;
  @override
  Widget build(BuildContext context) {
    final order = kind == 'order';
    final feedback = kind == 'feedback';
    return PageFrame(
      title: order
          ? 'Order confirmed'
          : feedback
          ? 'Thank you'
          : 'Password reset',
      back: false,
      bottom: PrimaryButton(
        order
            ? 'Track your order'
            : feedback
            ? 'Back to home'
            : 'Back to login',
        onPressed: () {
          if (order) {
            Navigator.pushReplacementNamed(context, '/track');
          } else if (feedback) {
            home(context);
          } else {
            Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
          }
        },
        icon: Icons.arrow_forward,
      ),
      child: Column(
        children: [
          const SizedBox(height: 110),
          Surface(
            padding: const EdgeInsets.symmetric(vertical: 36),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF0D6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    feedback ? Icons.favorite_rounded : Icons.check_rounded,
                    size: 62,
                    color: orange,
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  order
                      ? 'Your order is confirmed!'
                      : feedback
                      ? 'You made our day!'
                      : 'All set!',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    order
                        ? 'Thank you & see you soon.\nYour next delicious moment is on its way.'
                        : feedback
                        ? 'Thank you for sharing your experience.\nWe look forward to serving you again.'
                        : 'Password reset flow completed.\nThis demo does not update a real account.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: muted, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          if (order)
            const Text(
              'LOCAL DEMO ORDER · No payment was charged',
              style: TextStyle(color: muted, fontSize: 10),
            ),
        ],
      ),
    );
  }
}
