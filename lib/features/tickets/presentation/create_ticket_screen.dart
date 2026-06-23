import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_controller.dart';
import '../../../core/theme/glassmorphism.dart';

class CreateTicketScreen extends ConsumerStatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  ConsumerState<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends ConsumerState<CreateTicketScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  XFile? _image;
  Uint8List? _imageBytes;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _showPermissionSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        if (!mounted) return;
        setState(() {
          _image = pickedFile;
          _imageBytes = bytes;
        });
      }
    } on PlatformException catch (e) {
      final isPermissionIssue =
          e.code.contains('access_denied') ||
          e.code.contains('permission') ||
          e.code.contains('camera');

      if (isPermissionIssue) {
        _showPermissionSnackBar(
          source == ImageSource.camera
              ? 'Izin kamera ditolak. Aktifkan izin kamera di pengaturan aplikasi.'
              : 'Izin galeri ditolak. Aktifkan izin foto/galeri di pengaturan aplikasi.',
        );
        return;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memilih gambar: ${e.message ?? e.code}')),
        );
      }
    }
  }

  Future<void> _submitTicket() async {
    if (_titleController.text.trim().isEmpty || _descController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul dan deskripsi wajib diisi.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(appControllerProvider).createTicket(
        title: _titleController.text,
        description: _descController.text,
        imagePath: _image?.path,
        imageBytes: _imageBytes,
        imageFileName: _image?.name,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tiket berhasil dibuat.')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuat tiket: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fg = theme.colorScheme.onSurface;
    final fgSub = fg.withValues(alpha: 0.6);
    final fgMuted = fg.withValues(alpha: 0.4);

    return GradientScaffold(
      appBar: glassAppBar(title: 'Buat Tiket Baru'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 500),
                tween: Tween(begin: 0, end: 1),
                builder: (context, value, child) => Opacity(
                  opacity: value,
                  child: Transform.translate(offset: Offset(0, (1 - value) * 12), child: child),
                ),
                child: GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.confirmation_num_outlined, color: AGColors.accentCyan),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Lengkapi detail kendala agar tim support bisa menangani lebih cepat.',
                          style: TextStyle(color: fgSub),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GlassCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      style: TextStyle(color: fg),
                      decoration: InputDecoration(
                        labelText: 'Judul Masalah',
                        prefixIcon: Icon(Icons.title, color: fgMuted),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _descController,
                      maxLines: 4,
                      style: TextStyle(color: fg),
                      decoration: InputDecoration(
                        labelText: 'Deskripsi Detail',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(color: AGColors.glassBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(color: AGColors.glassBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: const BorderSide(color: AGColors.accentCyan, width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              GlassCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.attachment, color: AGColors.accentCyan),
                        const SizedBox(width: 8),
                        Text('Lampiran',
                            style: TextStyle(color: fg.withValues(alpha: 0.9), fontSize: 16, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: _imageBytes != null
                          ? ClipRRect(
                              key: const ValueKey('ticket-image-preview'),
                              borderRadius: BorderRadius.circular(14),
                              child: Image.memory(
                                _imageBytes!,
                                height: 210,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              key: const ValueKey('ticket-image-empty'),
                              height: 140,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: fg.withValues(alpha: 0.1)),
                                color: fg.withValues(alpha: 0.03),
                              ),
                              child: Text('Belum ada gambar terpilih',
                                  style: TextStyle(color: fgMuted)),
                            ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _pickImage(ImageSource.camera),
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Kamera'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _pickImage(ImageSource.gallery),
                            icon: const Icon(Icons.photo),
                            label: const Text('Galeri'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitTicket,
                      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                      child: const Text('Kirim Laporan'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}