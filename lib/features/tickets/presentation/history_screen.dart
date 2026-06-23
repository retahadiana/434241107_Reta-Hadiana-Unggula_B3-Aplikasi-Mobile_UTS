import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_controller.dart';
import '../../../core/theme/glassmorphism.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  String _formatDate(DateTime raw) {
    final dt = raw.toLocal();
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(appControllerProvider).activityHistory;
    final theme = Theme.of(context);
    final fg = theme.colorScheme.onSurface;
    final fgSub = fg.withValues(alpha: 0.6);
    final fgMuted = fg.withValues(alpha: 0.4);

    if (history.isEmpty) {
      return GradientScaffold(
        appBar: glassAppBar(title: 'Riwayat & Tracking Aktivitas'),
        body: SafeArea(
          child: Center(
            child: GlassCard(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history_toggle_off, size: 34, color: fgMuted),
                  const SizedBox(height: 8),
                  Text('Belum ada riwayat aktivitas.',
                      style: TextStyle(color: fgSub)),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return GradientScaffold(
      appBar: glassAppBar(title: 'Riwayat & Tracking Aktivitas'),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: history.length,
          itemBuilder: (context, index) {
            final item = history[index];
            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 220 + (index * 45)),
              tween: Tween(begin: 0, end: 1),
              builder: (context, value, child) => Opacity(
                opacity: value,
                child: Transform.translate(offset: Offset(0, (1 - value) * 8), child: child),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GlassCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AGColors.accentCyan.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.timeline, color: AGColors.accentCyan, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.message, style: TextStyle(color: fg)),
                            const SizedBox(height: 2),
                            Text('${item.actorName} • ${_formatDate(item.createdAt)}',
                                style: TextStyle(color: fgSub, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

