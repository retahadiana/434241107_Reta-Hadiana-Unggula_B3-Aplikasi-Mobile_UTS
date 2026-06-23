import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_controller.dart';
import '../../../core/permissions.dart';
import '../../../core/theme/glassmorphism.dart';
import '../../../models/profile_model.dart';
import '../../auth/presentation/profile_screen.dart';
import '../../tickets/presentation/create_ticket_screen.dart';
import '../../tickets/presentation/dashboard_screen.dart';
import '../../tickets/presentation/notifications_screen.dart';
import '../../tickets/presentation/ticket_list_screen.dart';
import 'settings_screen.dart';

class HomeShellScreen extends ConsumerStatefulWidget {
  const HomeShellScreen({super.key});

  @override
  ConsumerState<HomeShellScreen> createState() => _HomeShellScreenState();
}

class _HomeShellScreenState extends ConsumerState<HomeShellScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(appControllerProvider);
    final user = controller.currentUser;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final fg = dark ? Colors.white : AGColors.deepNavy;
    final fgSub = fg.withValues(alpha: 0.6);

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final pages = <Widget>[
      const DashboardScreen(),
      const TicketListScreen(),
      const NotificationsScreen(),
      const ProfileScreen(),
    ];

    final titles = <String>[
      'Dashboard',
      'Daftar Tiket',
      'Notifikasi',
      'Profil',
    ];

    return GradientScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(titles[_index], style: TextStyle(color: fg, fontWeight: FontWeight.w600)),
            Text(user.role.value, style: TextStyle(color: fgSub, fontSize: 12)),
          ],
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'Pengaturan',
            icon: Icon(Icons.settings, color: fg.withValues(alpha: 0.7)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
              );
            },
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: () async {
              await ref.read(appControllerProvider).logout();
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
              }
            },
            icon: Icon(Icons.logout, color: fg.withValues(alpha: 0.7)),
          ),
        ],
      ),
      body: SafeArea(child: pages[_index]),
      floatingActionButton: _index == 1 &&
              PermissionGuard.hasPermission(user.role, AppPermission.createTicket)
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) => const CreateTicketScreen()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Ticket'),
              elevation: 0,
              backgroundColor: dark ? AGColors.accentCyan : AGColors.softPurple,
              foregroundColor: Colors.white,
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: <Widget>[
          const NavigationDestination(icon: Icon(Icons.space_dashboard), label: 'Dashboard'),
          const NavigationDestination(icon: Icon(Icons.confirmation_number), label: 'Tiket'),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: controller.unreadNotificationCount > 0,
              label: Text(controller.unreadNotificationCount.toString()),
              child: const Icon(Icons.notifications),
            ),
            label: 'Notifikasi',
          ),
          const NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
