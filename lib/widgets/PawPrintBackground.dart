import 'package:flutter/material.dart';
import 'package:social_media/colors/colors.dart';

class PawPrintBackground extends StatelessWidget {
  final Widget child;
  const PawPrintBackground({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PawPrintBackgroundPainter(),
      child: child,
    );
  }
}

class PawPrintBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = kPrimaryColor.withOpacity(0.08);
    final icon = Icons.pets;

    final pawOffsets = [
      Offset(20, 20),
      Offset(size.width * 0.3, size.height * 0.15),
      Offset(size.width * 0.7, size.height * 0.05),
      Offset(size.width * 0.8, size.height * 0.3),
      Offset(size.width * 0.2, size.height * 0.7),
    ];

    for (final offset in pawOffsets) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(icon.codePoint),
          style: TextStyle(
            fontSize: 28,
            fontFamily: icon.fontFamily,
            package: icon.fontPackage,
            color: paint.color,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
