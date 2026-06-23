import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_controller.dart';
import '../../../core/permissions.dart';
import '../../../core/theme/glassmorphism.dart';
import '../../../models/ticket_model.dart';
import '../../../models/profile_model.dart';

class TicketDetailScreen extends ConsumerStatefulWidget {
  final String ticketId;

  const TicketDetailScreen({super.key, required this.ticketId});

  @override
  ConsumerState<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends ConsumerState<TicketDetailScreen> {
  final _assignedController = TextEditingController();
  final _commentController = TextEditingController();
  TicketStatus? _selectedStatus;
  bool _isBusy = false;

  String _formatDate(DateTime raw) {
    final dt = raw.toLocal();
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  bool _isSupport(Profile? profile) {
    if (profile == null) {
      return false;
    }
    return PermissionGuard.hasPermission(
      profile.role,
      AppPermission.updateTicketStatus,
    );
  }

  @override
  void initState() {
    super.initState();
    final ticket = ref.read(appControllerProvider).getTicketById(widget.ticketId);
    if (ticket != null) {
      _selectedStatus = ticket.status;
      _assignedController.text = ticket.assignedTo ?? '';
    }
  }

  @override
  void dispose() {
    _assignedController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitComment() async {
    final message = _commentController.text.trim();
    if (message.isEmpty) {
      return;
    }

    setState(() => _isBusy = true);
    try {
      await ref
          .read(appControllerProvider)
          .addComment(ticketId: widget.ticketId, message: message);
      _commentController.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim komentar: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isBusy = false);
      }
    }
  }

  Future<void> _saveSupportUpdate() async {
    final selectedStatus = _selectedStatus;
    if (selectedStatus == null) {
      return;
    }

    setState(() => _isBusy = true);

    try {
      await ref.read(appControllerProvider).updateTicketStatus(
            ticketId: widget.ticketId,
            newStatus: selectedStatus,
          );

      final assignee = _assignedController.text.trim();
      if (assignee.isNotEmpty) {
        await ref
            .read(appControllerProvider)
            .assignTicket(ticketId: widget.ticketId, assigneeName: assignee);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perubahan tiket berhasil disimpan.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan perubahan: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isBusy = false);
      }
    }
  }

  Future<void> _setStatus(TicketStatus status) async {
    setState(() => _selectedStatus = status);
    await _saveSupportUpdate();
  }

  Future<void> _openSupportActionsSheet() async {
    final ticket = ref.read(appControllerProvider).getTicketById(widget.ticketId);
    if (ticket == null) {
      return;
    }

    _assignedController.text = ticket.assignedTo ?? _assignedController.text;
    _selectedStatus ??= ticket.status;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        TicketStatus selected = _selectedStatus ?? ticket.status;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('Aksi Helpdesk/Admin',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<TicketStatus>(
                    initialValue: selected,
                    dropdownColor: const Color(0xFF192A56),
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'Update Status'),
                    items: TicketStatus.values
                        .map(
                          (status) => DropdownMenuItem<TicketStatus>(
                            value: status,
                            child: Text(status.label),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setModalState(() => selected = value);
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _assignedController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'Assign Ticket Ke'),
                  ),
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: _isBusy
                        ? null
                        : () async {
                            setState(() => _selectedStatus = selected);
                            Navigator.pop(context);
                            await _saveSupportUpdate();
                          },
                    icon: const Icon(Icons.save),
                    label: const Text('Simpan Perubahan'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatusStep(
    BuildContext context,
    TicketStatus status,
    int currentStatusIndex,
    bool isLast,
    bool canEdit,
    VoidCallback? onTap,
  ) {
    final statusIndex = TicketStatus.values.indexOf(status);
    final isDone = statusIndex <= currentStatusIndex;
    final isCurrent = statusIndex == currentStatusIndex;
    final theme = Theme.of(context);
    final fg = theme.colorScheme.onSurface;
    final fgSub = fg.withValues(alpha: 0.6);
    final fgMuted = fg.withValues(alpha: 0.4);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isCurrent ? AGColors.accentCyan.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isCurrent
                ? AGColors.accentCyan.withValues(alpha: 0.4)
                : fg.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 26,
              child: Column(
                children: <Widget>[
                  Icon(
                    isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: isCurrent
                        ? AGColors.accentCyan
                        : isDone
                            ? const Color(0xFF00CEC9)
                            : fgMuted,
                    size: 20,
                  ),
                  if (!isLast)
                    Container(
                      margin: const EdgeInsets.only(top: 3),
                      width: 2,
                      height: 34,
                      color: isDone
                          ? AGColors.accentCyan.withValues(alpha: 0.4)
                          : fg.withValues(alpha: 0.1),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(status.label,
                        style: TextStyle(
                          color: isCurrent ? fg : fgSub,
                          fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                        )),
                    const SizedBox(height: 2),
                    Text(
                      isCurrent
                          ? 'Status aktif saat ini'
                          : canEdit
                              ? 'Ketuk untuk ubah status'
                              : 'Menunggu progres',
                      style: TextStyle(color: fgMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            if (canEdit) Icon(Icons.chevron_right, size: 18, color: fgMuted),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(appControllerProvider);
    final profile = controller.currentUser;
    final ticket = controller.getTicketById(widget.ticketId);
    final theme = Theme.of(context);
    final fg = theme.colorScheme.onSurface;
    final fgSub = fg.withValues(alpha: 0.6);
    final fgMuted = fg.withValues(alpha: 0.4);

    if (ticket == null) {
      return GradientScaffold(
        appBar: glassAppBar(title: 'Detail Tiket'),
        body: Center(child: Text('Tiket tidak ditemukan.', style: TextStyle(color: fgSub))),
      );
    }

    final currentStatusIndex = TicketStatus.values.indexOf(ticket.status);

    return GradientScaffold(
      appBar: glassAppBar(title: 'Detail Tiket'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 450),
              tween: Tween(begin: 0, end: 1),
              builder: (context, value, child) => Opacity(
                opacity: value,
                child: Transform.translate(offset: Offset(0, (1 - value) * 10), child: child),
              ),
              child: GlassCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ticket.title,
                        style: TextStyle(color: fg, fontSize: 22, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text(ticket.description, style: TextStyle(color: fgSub)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        Chip(label: Text('Status: ${ticket.status.label}')),
                        Chip(label: Text('Reporter: ${ticket.userName}')),
                        Chip(label: Text('Assigned: ${ticket.assignedTo ?? '-'}')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (_isSupport(profile)) ...<Widget>[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _isBusy ? null : _openSupportActionsSheet,
                icon: const Icon(Icons.admin_panel_settings),
                label: const Text('Aksi Helpdesk/Admin'),
              ),
            ],
            if (ticket.imageUrl != null && ticket.imageUrl!.isNotEmpty) ...<Widget>[
              const SizedBox(height: 12),
              GlassCard(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.network(
                        ticket.imageUrl!,
                        height: 240,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 240,
                            width: double.infinity,
                            alignment: Alignment.center,
                            color: fg.withValues(alpha: 0.05),
                            child: Text('Lampiran gambar tidak dapat ditampilkan',
                                style: TextStyle(color: fgSub)),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          'Lampiran: ${ticket.imageUrl}',
                          style: TextStyle(color: fgMuted, fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            Text('Tracking Status',
                style: TextStyle(color: fg.withValues(alpha: 0.9), fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...TicketStatus.values.asMap().entries.map((entry) {
              final index = entry.key;
              final status = entry.value;
              final canEdit = _isSupport(profile);
              return _buildStatusStep(
                context,
                status,
                currentStatusIndex,
                index == TicketStatus.values.length - 1,
                canEdit,
                canEdit ? () => _setStatus(status) : null,
              );
            }),
            const SizedBox(height: 16),
            Text('Riwayat Aktivitas',
                style: TextStyle(color: fg.withValues(alpha: 0.9), fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...ticket.tracking
                .map(
                  (trace) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GlassCard(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Icon(Icons.timeline, color: AGColors.accentCyan, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(trace.message, style: TextStyle(color: fg)),
                                Text('${trace.actorName} • ${_formatDate(trace.createdAt)}',
                                    style: TextStyle(color: fgSub, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
            const SizedBox(height: 16),
            Text('Komentar / Reply',
                style: TextStyle(color: fg.withValues(alpha: 0.9), fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...ticket.comments
                .map(
                  (comment) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GlassCard(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(comment.message, style: TextStyle(color: fg)),
                          const SizedBox(height: 4),
                          Text(
                            '${comment.authorName} (${comment.authorRole.value}) • ${_formatDate(comment.createdAt)}',
                            style: TextStyle(color: fgSub, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              style: TextStyle(color: fg),
              decoration: const InputDecoration(
                labelText: 'Tulis komentar',
              ),
              minLines: 1,
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _isBusy ? null : _submitComment,
              icon: const Icon(Icons.send),
              label: const Text('Kirim Reply'),
            ),
          ],
        ),
      ),
    );
  }
}

