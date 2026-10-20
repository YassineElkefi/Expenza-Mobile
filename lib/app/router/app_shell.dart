import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';

class AppShell extends ConsumerWidget {
  const AppShell({required this.child, super.key});

  final Widget child;

  static const _destinations = [
    _Destination('Dashboard', '/dashboard', Icons.dashboard_outlined),
    _Destination(
      'Accounts',
      '/accounts',
      Icons.account_balance_wallet_outlined,
    ),
    _Destination('Transactions', '/transactions', Icons.swap_vert_rounded),
    _Destination('Installments', '/installments', Icons.payments_outlined),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final location = GoRouterState.of(context).uri.path;

    final selectedIndex = _destinations.indexWhere(
      (destination) => destination.path == location,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'EXPENZA',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
        actions: [
          IconButton(
            tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
            onPressed: () {
              ref.read(themeModeProvider.notifier).toggle();
            },
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(top: false, child: child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
        onDestinationSelected: (index) {
          context.go(_destinations[index].path);
        },
        destinations: _destinations
            .map(
              (destination) => NavigationDestination(
                icon: Icon(destination.icon),
                label: destination.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _Destination {
  const _Destination(this.label, this.path, this.icon);

  final String label;
  final String path;
  final IconData icon;
}
