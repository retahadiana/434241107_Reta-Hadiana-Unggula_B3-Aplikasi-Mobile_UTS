import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_controller.dart';
import '../../../core/theme/glassmorphism.dart';
import 'ticket_detail_screen.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(appControllerProvider);
    final notifications = controller.myNotifications;
    final theme = Theme.of(context);
    final fg = theme.colorScheme.onSurface;
    final fgSub = fg.withValues(alpha: 0.6);
    final fgMuted = fg.withValues(alpha: 0.4);

    if (notifications.isEmpty) {
      return Center(
        child: Text('Belum ada notifikasi.',
            style: TextStyle(color: fgSub)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final n = notifications[index];
        return GlassCard(
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              ref.read(appControllerProvider).markNotificationRead(n.id);
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => TicketDetailScreen(ticketId: n.ticketId),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: n.isRead
                      ? Colors.transparent
                      : AGColors.accentCyan.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 4,
                    height: 50,
                    decoration: BoxDecoration(
                      color: n.isRead
                          ? fg.withValues(alpha: 0.15)
                          : AGColors.accentCyan,
                      borderRadius: BorderRadius.circular(99),
                      boxShadow: n.isRead
                          ? null
                          : [
                              BoxShadow(
                                color: AGColors.accentCyan.withValues(alpha: 0.4),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(n.title,
                            style: TextStyle(
                              color: fg,
                              fontWeight: n.isRead ? FontWeight.w400 : FontWeight.w600,
                            )),
                        const SizedBox(height: 4),
                        Text(n.message, style: TextStyle(color: fgSub)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${n.createdAt.hour.toString().padLeft(2, '0')}:${n.createdAt.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(color: fgMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

