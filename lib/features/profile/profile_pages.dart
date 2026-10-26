import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../shared/widgets.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return PageFrame(
      title: 'Profile',
      tab: 3,
      child: Column(
        children: [
          const SizedBox(height: 12),
          const CircleAvatar(
            radius: 54,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/avatar.png'),
            ),
          ),
          const SizedBox(height: 24),
          Surface(
            child: Column(
              children: [
                const SizedBox(height: 8),
                Text(state.name, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(state.email, style: const TextStyle(color: muted)),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 8),
                for (final entry in [
                  ('Personal info', Icons.person_outline, '/personal'),
                  ('Saved favourites', Icons.favorite_border, '/saved'),
                  ('Payment methods', Icons.credit_card, '/methods'),
                  ('Security', Icons.shield_outlined, '/security'),
                  ('Permissions', Icons.verified_user_outlined, '/permissions'),
                  ('Settings', Icons.settings_outlined, '/settings'),
                ])
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                    leading: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF414141)
                            : const Color(0xFFEDEDED),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(entry.$2, size: 22),
                    ),
                    title: Text(
                      entry.$1,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 20),
                    onTap: () => go(context, entry.$3),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (_) => false,
            ),
            child: const Text(
              'Back to demo login',
              style: TextStyle(color: muted, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});
  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(),
      email = TextEditingController(),
      phone = TextEditingController();
  bool initialized = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      final state = AppScope.of(context);
      name.text = state.name;
      email.text = state.email;
      phone.text = state.phone;
      initialized = true;
    }
  }

  @override
  void dispose() {
    for (final c in [name, email, phone]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Personal info',
    bottom: PrimaryButton(
      'Save changes',
      orangeStyle: true,
      onPressed: () async {
        if (!form.currentState!.validate()) return;
        final state = AppScope.of(context);
        state.name = name.text.trim();
        state.email = email.text.trim();
        state.phone = phone.text.trim();
        await state.persist();
        if (context.mounted) {
          message(
            context,
            state.storageError.isEmpty
                ? 'Your profile has been saved.'
                : state.storageError,
          );
        }
      },
    ),
    child: Form(
      key: form,
      child: Surface(
        child: Column(
          children: [
            const SizedBox(height: 12),
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/avatar.png'),
            ),
            const SizedBox(height: 30),
            LabeledField('Name', controller: name, validator: requiredField),
            LabeledField(
              'Email',
              controller: email,
              validator: emailField,
              type: TextInputType.emailAddress,
            ),
            LabeledField(
              'Phone',
              controller: phone,
              validator: (value) =>
                  RegExp(r'^\+?[\d\s()-]{7,20}$').hasMatch(value ?? '')
                  ? null
                  : 'Enter a valid phone number',
              type: TextInputType.phone,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    ),
  );
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return PageFrame(
      title: 'Settings',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Make yourself at home'),
          Surface(
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Dark appearance',
                    style: TextStyle(fontSize: 14),
                  ),
                  subtitle: const Text(
                    'A softer view after hours',
                    style: TextStyle(color: muted, fontSize: 12),
                  ),
                  value: state.dark,
                  activeThumbColor: orange,
                  onChanged: (value) {
                    state.dark = value;
                    state.persist();
                  },
                ),
                const Divider(),
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Language', style: TextStyle(fontSize: 14)),
                  trailing: Text(
                    'English',
                    style: TextStyle(color: muted, fontSize: 12),
                  ),
                ),
                const Divider(),
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Version', style: TextStyle(fontSize: 14)),
                  trailing: Text(
                    '1.0.0 · Demo',
                    style: TextStyle(color: muted, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const SectionTitle('About Chief’s'),
          const Text(
            'Good food. Thoughtfully delivered.\n\nA Flutter implementation of the Chief’s Food App UI Kit from Pixso. This app demonstrates the complete ordering experience with local data.',
            style: TextStyle(color: muted, fontSize: 13),
          ),
          const SizedBox(height: 28),
          TextButton(
            onPressed: () => go(context, '/onboarding'),
            child: const Text(
              'View the introduction again',
              style: TextStyle(color: orange),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoPage extends StatelessWidget {
  const InfoPage({super.key, required this.kind});
  final String kind;
  @override
  Widget build(BuildContext context) {
    final security = kind == 'security', permissions = kind == 'permissions';
    return PageFrame(
      title: security
          ? 'Security'
          : permissions
          ? 'Permissions'
          : 'Notifications',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Icon(
            security
                ? Icons.shield_outlined
                : permissions
                ? Icons.verified_user_outlined
                : Icons.notifications_none_rounded,
            size: 60,
            color: orange,
          ),
          const SizedBox(height: 28),
          Text(
            security
                ? 'Your account, your control'
                : permissions
                ? 'You are in control'
                : 'A little update',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          if (security) ...[
            const Text(
              'This local demo does not store passwords or connect to an authentication service.',
              style: TextStyle(color: muted),
            ),
            const SizedBox(height: 28),
            PrimaryButton(
              'Try password reset',
              onPressed: () => go(context, '/forgot'),
            ),
          ] else if (permissions) ...[
            for (final item in [
              ('Location', 'Delivery addresses are entered manually.'),
              ('Camera', 'Card scanning is simulated. No camera is accessed.'),
              ('Notifications', 'Updates appear inside the app only.'),
            ])
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Surface(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.$1,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.$2,
                        style: const TextStyle(color: muted, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Not requested',
                        style: TextStyle(color: orange, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
          ] else ...[
            Surface(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.restaurant, color: orange),
                title: const Text(
                  'Welcome to Chief’s',
                  style: TextStyle(fontSize: 14),
                ),
                subtitle: const Text(
                  'Your next delicious moment starts here. Explore the menu and find a new favourite.',
                  style: TextStyle(color: muted, fontSize: 12),
                ),
                onTap: () => go(context, '/menu'),
              ),
            ),
            const SizedBox(height: 20),
            if (AppScope.of(context).latestOrder != null)
              Surface(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.shopping_bag_outlined,
                    color: orange,
                  ),
                  title: const Text(
                    'Your demo order',
                    style: TextStyle(fontSize: 14),
                  ),
                  subtitle: Text(
                    AppScope.of(context).latestOrder!.received
                        ? 'Your order has been marked as received.'
                        : 'Your order is being prepared.',
                    style: const TextStyle(color: muted, fontSize: 12),
                  ),
                  onTap: () => go(context, '/track'),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class MethodsPage extends StatelessWidget {
  const MethodsPage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Payment methods',
    bottom: PrimaryButton(
      'Add demo payment method',
      orangeStyle: true,
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (sheet) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add a payment method',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Explore the simulated card scanner.\nNo financial details will be requested or saved.',
                  style: TextStyle(color: muted),
                ),
                const SizedBox(height: 28),
                PrimaryButton(
                  'Open demo scanner',
                  onPressed: () {
                    Navigator.pop(sheet);
                    go(context, '/scan');
                  },
                  icon: Icons.credit_card,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    ),
    child: Column(
      children: [
        const SizedBox(height: 12),
        Surface(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.credit_card, color: orange, size: 34),
            title: const Text('Demo card •••• 4242'),
            subtitle: const Text(
              'For local checkout only',
              style: TextStyle(color: muted, fontSize: 12),
            ),
            trailing: const Icon(Icons.check_circle, color: orange),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'The demo card is built in. Real cards cannot be added and no payment provider is connected.',
          style: TextStyle(color: muted, fontSize: 12),
        ),
      ],
    ),
  );
}

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Scan card · Demo',
    bottom: PrimaryButton(
      'Simulate card scan',
      onPressed: () => go(context, '/scan-success'),
    ),
    child: Column(
      children: [
        const SizedBox(height: 70),
        Container(
          width: double.infinity,
          height: 215,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFF303030),
            border: Border.all(color: orange, width: 2),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.credit_card, size: 40, color: orange),
              Text(
                '••••   ••••   ••••   4242',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                'DEMO CARD',
                style: TextStyle(
                  color: Colors.white70,
                  letterSpacing: 3,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 34),
        Text(
          'Place your card in the frame',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        const Text(
          'This is a simulated scanner.\nYour camera is not accessed.',
          textAlign: TextAlign.center,
          style: TextStyle(color: muted, fontSize: 13),
        ),
      ],
    ),
  );
}

class ScanSuccessPage extends StatelessWidget {
  const ScanSuccessPage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Demo card ready',
    bottom: PrimaryButton(
      'Back to payment methods',
      onPressed: () => Navigator.pushReplacementNamed(context, '/methods'),
    ),
    child: const Column(
      children: [
        SizedBox(height: 100),
        Icon(Icons.check_circle_outline, size: 110, color: orange),
        SizedBox(height: 32),
        Text(
          'Demo scan completed',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 18),
        Text(
          'Your built-in demo card is ready.\nNo card was scanned or saved.',
          textAlign: TextAlign.center,
          style: TextStyle(color: muted),
        ),
      ],
    ),
  );
}
