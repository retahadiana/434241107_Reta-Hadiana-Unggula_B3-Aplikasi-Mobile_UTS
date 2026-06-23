import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_controller.dart';
import '../../../core/theme/glassmorphism.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    // Clear any previous errors when entering reset password screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appControllerProvider).clearError();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    if (_emailController.text.trim().isEmpty) return;

    setState(() => _isSending = true);
    try {
      await ref.read(appControllerProvider).resetPassword(
            email: _emailController.text.trim(),
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permintaan reset password berhasil diproses.'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim reset password: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fg = theme.colorScheme.onSurface;
    final fgSub = fg.withValues(alpha: 0.6);
    final fgMuted = fg.withValues(alpha: 0.4);

    return GradientScaffold(
      appBar: glassAppBar(title: 'Reset Password'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Pulihkan akun Anda',
                      style: TextStyle(color: fg, fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text('Masukkan email terdaftar untuk menerima tautan reset password.',
                      style: TextStyle(color: fgSub)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    style: TextStyle(color: fg),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined, color: fgMuted),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  _isSending
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _sendResetEmail,
                          child: const Text('Kirim Reset Password'),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

