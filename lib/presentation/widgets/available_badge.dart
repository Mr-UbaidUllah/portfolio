import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AvailableBadge extends StatelessWidget {
  const AvailableBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF6C63FF).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF00FF94),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF00FF94),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .scale(begin: const Offset(1, 1), end: const Offset(1.5, 1.5), duration: 1.seconds, curve: Curves.easeInOut)
              .fadeOut(duration: 1.seconds),
          const SizedBox(width: 10),
          const Text(
            'AVAILABLE FOR WORK',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Color(0xFFBEB6FF),
            ),
          ),
        ],
      ),
    );
  }
}
