import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_controller.dart';
import '../../../core/permissions.dart';
import '../../../core/theme/glassmorphism.dart';
import '../../../models/profile_model.dart';
import '../../tickets/presentation/history_screen.dart';
import 'role_provisioning_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(appControllerProvider);
    final profile = controller.currentUser;
    final theme = Theme.of(context);
    final fg = theme.colorScheme.onSurface;
    final fgSub = fg.withValues(alpha: 0.6);

    if (profile == null) {
      return Center(child: Text('Tidak ada profil aktif.', style: TextStyle(color: fgSub)));
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: <Widget>[
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 450),
          tween: Tween(begin: 0, end: 1),
          builder: (context, value, child) => Opacity(
            opacity: value,
            child: Transform.translate(offset: Offset(0, (1 - value) * 10), child: child),
          ),
          child: _ProfileHeader(profile: profile),
        ),
        const SizedBox(height: 16),
        GlassCard(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.history, color: AGColors.accentCyan),
                title: Text('Riwayat & Tracking', style: TextStyle(color: fg, fontWeight: FontWeight.w500)),
                subtitle: Text('Lihat histori aktivitas tiket',
                    style: TextStyle(color: fgSub)),
                trailing: Icon(Icons.chevron_right, color: fg.withValues(alpha: 0.4)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(builder: (_) => const HistoryScreen()),
                  );
                },
              ),
              Divider(height: 1, color: fg.withValues(alpha: 0.08)),
              ListTile(
                leading: const Icon(Icons.dark_mode, color: AGColors.accentCyan),
                title: Text('Dark Mode', style: TextStyle(color: fg, fontWeight: FontWeight.w500)),
                subtitle: Text(
                  controller.themeMode == ThemeMode.dark
                      ? 'Tampilan gelap aktif'
                      : 'Tampilan terang aktif',
                  style: TextStyle(color: fgSub),
                ),
                trailing: Switch(
                  value: controller.themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    ref
                        .read(appControllerProvider)
                        .setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                  },
                ),
              ),
            ],
          ),
        ),
        if (PermissionGuard.hasPermission(profile.role, AppPermission.manageUserRoles))
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: GlassCard(
              child: ListTile(
                leading: const Icon(Icons.admin_panel_settings, color: AGColors.softPurple),
                title: Text('Provisioning Role User', style: TextStyle(color: fg, fontWeight: FontWeight.w500)),
                subtitle: Text('Atur role User/Helpdesk/Admin',
                    style: TextStyle(color: fgSub)),
                trailing: Icon(Icons.chevron_right, color: fg.withValues(alpha: 0.4)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => const RoleProvisioningScreen(),
                    ),
                  );
                },
              ),
            ),
          ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            side: BorderSide(color: const Color(0xFFFF6B6B).withValues(alpha: 0.5)),
            foregroundColor: const Color(0xFFFF6B6B),
          ),
          onPressed: () async {
            await ref.read(appControllerProvider).logout();
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
            }
          },
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
        ),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final Profile profile;

  const _ProfileHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fg = theme.colorScheme.onSurface;
    final fgSub = fg.withValues(alpha: 0.6);

    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AGColors.accentCyan.withValues(alpha: 0.5), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AGColors.accentCyan.withValues(alpha: 0.2),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 26,
                  backgroundColor: AGColors.accentCyan.withValues(alpha: 0.15),
                  child: Text(
                    profile.fullName.substring(0, 1).toUpperCase(),
                    style: const TextStyle(color: AGColors.accentCyan, fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(profile.fullName,
                        style: TextStyle(color: fg, fontSize: 20, fontWeight: FontWeight.w600)),
                    Text(profile.email, style: TextStyle(color: fgSub)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AGColors.softPurple.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AGColors.softPurple.withValues(alpha: 0.3)),
            ),
            child: Text('Role: ${profile.role.value}',
                style: const TextStyle(color: AGColors.softPurple, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}

