import 'package:flutter/material.dart';

class ToolCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final int level; // 1 to 5 dots

  const ToolCard({
    super.key,
    required this.title,
    required this.icon,
    required this.level,
  });

  @override
  State<ToolCard> createState() => _ToolCardState();
}

class _ToolCardState extends State<ToolCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focused) => setState(() => _isHovered = focused),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Semantics(
          label: '${widget.title}, proficiency level ${widget.level} out of 5',
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _isHovered ? const Color(0xFF1E1E3A) : const Color(0xFF161629),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isHovered ? const Color(0xFF00D2FF).withValues(alpha: 0.5) : Colors.white10,
                width: _isHovered ? 1.5 : 1.0,
              ),
              boxShadow: _isHovered ? [
                BoxShadow(
                  color: const Color(0xFF00D2FF).withValues(alpha: 0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                )
              ] : [],
            ),
            child: Column(
              children: [
                Icon(
                  widget.icon,
                  color: _isHovered ? Colors.white : const Color(0xFF00D2FF),
                  size: 28,
                ),
                const SizedBox(height: 12),
                Text(
                  widget.title,
                  style: TextStyle(
                    color: _isHovered ? Colors.white : Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index < widget.level
                            ? const Color(0xFF00D2FF)
                            : Colors.white.withValues(alpha: 0.1),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
