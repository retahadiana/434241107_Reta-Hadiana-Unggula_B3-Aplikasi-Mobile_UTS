import 'dart:ui';
import 'package:flutter/material.dart';

// ─── Color Palette ───────────────────────────────────────────────────────────
class AGColors {
  static const Color deepNavy = Color(0xFF192A56);
  static const Color charcoal = Color(0xFF2D3436);
  static const Color softPurple = Color(0xFF6C5CE7);
  static const Color accentBlue = Color(0xFF74B9FF);
  static const Color accentCyan = Color(0xFF00CEC9);
  static const Color glassFill = Color(0x14FFFFFF); // white 8%
  static const Color glassBorder = Color(0x26FFFFFF); // white 15%
  static const Color glassHighlight = Color(0x0DFFFFFF); // white 5%

  // Light-mode glass
  static const Color lightGlassFill = Color(0x8CFFFFFF); // white 55%
  static const Color lightGlassBorder = Color(0xB3FFFFFF); // white 70%
}

// ─── Brightness helpers ──────────────────────────────────────────────────────
bool _isDark(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;

// ─── Gradient Background Scaffold ────────────────────────────────────────────
/// A Scaffold replacement that renders a gradient background.
/// Automatically switches between dark and light palette.
class GradientScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  const GradientScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    final dark = _isDark(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.transparent,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: dark
                ? const <Color>[
                    AGColors.deepNavy,
                    AGColors.charcoal,
                    Color(0xFF1E1545),
                    AGColors.softPurple,
                  ]
                : const <Color>[
                    Color(0xFFE8DFFF), // soft lavender
                    Color(0xFFD6EAFF), // sky blue
                    Color(0xFFE0D4FF), // pastel purple
                    Color(0xFFC8E6FF), // light cyan
                  ],
            stops: const [0.0, 0.35, 0.7, 1.0],
          ),
        ),
        child: body,
      ),
    );
  }
}

// ─── Glassmorphism Card ──────────────────────────────────────────────────────
/// A frosted-glass card with backdrop blur. Adapts fill/border for light & dark.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final double blur;

  const GlassCard({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.borderRadius = 20,
    this.blur = 12,
  });

  @override
  Widget build(BuildContext context) {
    final dark = _isDark(context);

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: dark ? AGColors.glassFill : AGColors.lightGlassFill,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: dark ? AGColors.glassBorder : AGColors.lightGlassBorder,
                width: 1,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ─── Ticket Die-Cut Clipper ──────────────────────────────────────────────────
/// Creates semi-circular notches on both sides of a card, like a real ticket.
class TicketNotchClipper extends CustomClipper<Path> {
  final double notchRadius;

  TicketNotchClipper({this.notchRadius = 16});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(20),
      ),
    );

    // Left notch
    path.addOval(Rect.fromCircle(
      center: Offset(0, size.height * 0.5),
      radius: notchRadius,
    ));

    // Right notch
    path.addOval(Rect.fromCircle(
      center: Offset(size.width, size.height * 0.5),
      radius: notchRadius,
    ));

    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(TicketNotchClipper oldClipper) =>
      notchRadius != oldClipper.notchRadius;
}

// ─── Ticket Card (die-cut + glassmorphism) ───────────────────────────────────
/// A card that combines the die-cut ticket shape with the frosted glass effect.
class TicketCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final double notchRadius;

  const TicketCard({
    super.key,
    required this.child,
    this.margin,
    this.notchRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    final dark = _isDark(context);

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: ClipPath(
        clipper: TicketNotchClipper(notchRadius: notchRadius),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                color: dark ? AGColors.glassFill : AGColors.lightGlassFill,
                border: Border.all(
                  color: dark ? AGColors.glassBorder : AGColors.lightGlassBorder,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Gradient AppBar helper ──────────────────────────────────────────────────
PreferredSizeWidget glassAppBar({
  required String title,
  List<Widget>? actions,
  Widget? leading,
  bool automaticallyImplyLeading = true,
}) {
  return _GlassAppBar(
    title: title,
    actions: actions,
    leading: leading,
    automaticallyImplyLeading: automaticallyImplyLeading,
  );
}

class _GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;

  const _GlassAppBar({
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final dark = _isDark(context);

    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: dark ? Colors.white : AGColors.deepNavy,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: dark ? Colors.white : AGColors.deepNavy),
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }
}
