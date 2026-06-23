import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_controller.dart';
import '../../../core/permissions.dart';
import '../../../core/theme/glassmorphism.dart';
import '../../../models/profile_model.dart';
import '../../../models/ticket_model.dart';
import 'create_ticket_screen.dart';
import 'history_screen.dart';
import 'ticket_detail_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(appControllerProvider);
    final stats = controller.dashboardStats;
    final tickets = controller.visibleTickets;
    final user = controller.currentUser;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final fg = dark ? Colors.white : AGColors.deepNavy;
    final fgSub = fg.withValues(alpha: 0.6);
    final accent = dark ? AGColors.accentCyan : AGColors.softPurple;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        GlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Halo, ${user.fullName}',
                  style: TextStyle(color: fg, fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text('Role aktif: ${user.role.value}', style: TextStyle(color: accent)),
              const SizedBox(height: 2),
              Text('Pantau ringkasan performa tiket helpdesk Anda hari ini.',
                  style: TextStyle(color: fgSub)),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text('Ringkasan Tiket',
            style: TextStyle(color: fg.withValues(alpha: 0.9), fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        _StatsGrid(stats: stats, total: tickets.length),
        const SizedBox(height: 16),
        Row(
          children: <Widget>[
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(builder: (_) => const HistoryScreen()),
                  );
                },
                icon: const Icon(Icons.timeline),
                label: const Text('Riwayat'),
              ),
            ),
            const SizedBox(width: 8),
            if (PermissionGuard.hasPermission(user.role, AppPermission.createTicket))
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(builder: (_) => const CreateTicketScreen()),
                    );
                  },
                  icon: const Icon(Icons.add_circle),
                  label: const Text('Create Ticket'),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text('Tiket Terbaru',
            style: TextStyle(color: fg.withValues(alpha: 0.9), fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        if (tickets.isEmpty)
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: Text('Belum ada tiket aktif.', style: TextStyle(color: fgSub)),
          )
        else
          ...tickets.take(5).map(
                (ticket) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GlassCard(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => TicketDetailScreen(ticketId: ticket.id),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: accent.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(Icons.confirmation_number, color: accent, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(ticket.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: fg, fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 4),
                                  Text('${ticket.status.label} • ${ticket.userName}',
                                      style: TextStyle(color: fgSub, fontSize: 12)),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right, color: fg.withValues(alpha: 0.4)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final Map<TicketStatus, int> stats;
  final int total;

  const _StatsGrid({required this.stats, required this.total});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final fg = dark ? Colors.white : AGColors.deepNavy;
    final accent = dark ? AGColors.accentCyan : AGColors.softPurple;

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            _StatCard(
              title: 'Open',
              value: stats[TicketStatus.open] ?? 0,
              color: const Color(0xFF74B9FF),
            ),
            const SizedBox(width: 10),
            _StatCard(
              title: 'In Progress',
              value: stats[TicketStatus.inProgress] ?? 0,
              color: const Color(0xFFFFA502),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            _StatCard(
              title: 'Resolved',
              value: stats[TicketStatus.resolved] ?? 0,
              color: const Color(0xFF00CEC9),
            ),
            const SizedBox(width: 10),
            _StatCard(
              title: 'Closed',
              value: stats[TicketStatus.closed] ?? 0,
              color: dark ? Colors.white.withValues(alpha: 0.4) : AGColors.charcoal.withValues(alpha: 0.4),
            ),
          ],
        ),
        const SizedBox(height: 10),
        GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(Icons.summarize, color: accent),
              const SizedBox(width: 12),
              Text('Total tiket', style: TextStyle(color: fg)),
              const Spacer(),
              Text(
                '$total',
                style: TextStyle(color: fg, fontSize: 24, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int value;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final fgSub = dark ? Colors.white.withValues(alpha: 0.7) : AGColors.deepNavy.withValues(alpha: 0.6);

    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: TextStyle(color: fgSub, fontSize: 13)),
            const SizedBox(height: 8),
            Text(
              '$value',
              style: TextStyle(color: color, fontSize: 28, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
