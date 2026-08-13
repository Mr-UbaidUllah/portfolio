import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AvailableBadge extends StatelessWidget {
  const AvailableBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final bool reduceMotion = MediaQuery.of(context).accessibleNavigation || 
                             MediaQuery.of(context).disableAnimations;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF6C63FF).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF6C63FF).withValues(alpha: 0.2)),
      ),
      child: Semantics(
        label: 'Status: Available for work',
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF00FF94),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF00FF94).withValues(alpha: 0.5)),
                  ),
                )
                .animate(onPlay: (c) => reduceMotion ? c.stop() : c.repeat())
                .scale(begin: const Offset(1, 1), end: const Offset(2, 2), duration: 2.seconds)
                .fadeOut(duration: 2.seconds),
              ],
            ),
            const SizedBox(width: 12),
            const Text(
              'AVAILABLE FOR WORK',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                color: Color(0xFFBEB6FF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
