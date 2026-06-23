import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_controller.dart';
import '../../../core/permissions.dart';
import '../../../core/theme/glassmorphism.dart';
import '../../../models/profile_model.dart';

class RoleProvisioningScreen extends ConsumerStatefulWidget {
  const RoleProvisioningScreen({super.key});

  @override
  ConsumerState<RoleProvisioningScreen> createState() =>
      _RoleProvisioningScreenState();
}

class _RoleProvisioningScreenState extends ConsumerState<RoleProvisioningScreen> {
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    try {
      await ref.read(appControllerProvider).refreshProvisioningUsers();
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _assignRole(Profile user, UserRole role) async {
    setState(() => _loading = true);
    try {
      await ref.read(appControllerProvider).assignRoleToUser(
            targetUserId: user.id,
            role: role,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Role ${user.fullName} diubah menjadi ${role.value}.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengubah role: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = ref.watch(appControllerProvider);
    final current = app.currentUser;
    final theme = Theme.of(context);
    final fg = theme.colorScheme.onSurface;
    final fgSub = fg.withValues(alpha: 0.6);

    if (current == null ||
        !PermissionGuard.hasPermission(current.role, AppPermission.manageUserRoles)) {
      return GradientScaffold(
        appBar: glassAppBar(title: 'Provisioning Role User'),
        body: Center(
          child: Text('Hanya Admin yang dapat mengakses halaman ini.',
              style: TextStyle(color: fgSub)),
        ),
      );
    }

    final users = app.profilesForProvisioning;

    return GradientScaffold(
      appBar: glassAppBar(title: 'Provisioning Role User'),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (_, index) {
                    final user = users[index];
                    return GlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AGColors.softPurple.withValues(alpha: 0.15),
                            ),
                            child: Center(
                              child: Text(
                                user.fullName.substring(0, 1).toUpperCase(),
                                style: const TextStyle(color: AGColors.softPurple, fontWeight: FontWeight.w700, fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user.fullName,
                                    style: TextStyle(color: fg, fontWeight: FontWeight.w500)),
                                Text(user.email,
                                    style: TextStyle(color: fgSub, fontSize: 12)),
                              ],
                            ),
                          ),
                          DropdownButton<UserRole>(
                            value: user.role,
                            dropdownColor: theme.colorScheme.surface,
                            style: TextStyle(color: fg),
                            underline: const SizedBox(),
                            icon: Icon(Icons.arrow_drop_down, color: fgSub),
                            items: UserRole.values
                                .map(
                                  (role) => DropdownMenuItem<UserRole>(
                                    value: role,
                                    child: Text(role.value),
                                  ),
                                )
                                .toList(),
                            onChanged: (newRole) {
                              if (newRole == null || newRole == user.role) {
                                return;
                              }
                              _assignRole(user, newRole);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemCount: users.length,
                ),
        ),
      ),
    );
  }
}

