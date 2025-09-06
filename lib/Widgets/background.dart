import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF15345C), Color(0xFF0C2340)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Positioned.fill(
          child: Image.asset(
            'assets/images/app-bg.jpg',
            fit: BoxFit.cover,
            color: Colors.white.withValues(alpha: 0.1),
            colorBlendMode: BlendMode.softLight,
          ),
        ),
        const DiagonalStripe(angle: -0.6, opacity: 0.18),
        const DiagonalStripe(angle: 0.6, opacity: 0.14),
        const DiagonalStripe(angle: -0.6, opacity: 0.1, widthFactor: 0.35),
        const DotsOverlay(opacity: 0.12),
      ],
    );
  }
}

class DiagonalStripe extends StatelessWidget {
  final double angle;
  final double opacity;
  final double widthFactor;

  const DiagonalStripe({
    required this.angle,
    required this.opacity,
    this.widthFactor = 0.55,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: LayoutBuilder(
        builder: (_, constraints) {
          return Transform.rotate(
            angle: angle,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: constraints.maxWidth * widthFactor,
                height: constraints.maxHeight * 1.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: opacity * 0.05),
                      Colors.white.withValues(alpha: opacity),
                      Colors.white.withValues(alpha: opacity * 0.05),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DotsOverlay extends StatelessWidget {
  final double opacity;
  const DotsOverlay({required this.opacity, super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _DotsPainter(opacity),
        size: Size.infinite,
      ),
    );
  }
}

class _DotsPainter extends CustomPainter {
  final double opacity;
  _DotsPainter(this.opacity);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    const spacing = 16.0;
    const radius = 1.2;

    for (double y = spacing / 2; y < size.height; y += spacing) {
      for (double x = spacing / 2; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotsPainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}

