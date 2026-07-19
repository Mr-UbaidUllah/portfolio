import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavItem extends StatefulWidget {
  final String title;
  final bool isSelected;
  final String routePath;

  const NavItem({
    required this.title,
    required this.routePath,
    this.isSelected = false,
    super.key,
  });

  @override
  State<NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focused) => setState(() => _isHovered = focused),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Semantics(
          button: true,
          selected: widget.isSelected,
          label: 'Navigate to ${widget.title}',
          child: TextButton(
            onPressed: widget.isSelected ? null : () => context.go(widget.routePath),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    color: widget.isSelected || _isHovered ? Colors.white : Colors.white60,
                    fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 2,
                  width: widget.isSelected || _isHovered ? 24 : 0,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFFBEB6FF)],
                    ),
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      if (widget.isSelected || _isHovered)
                        BoxShadow(
                          color: const Color(0xFF6C63FF).withValues(alpha: 0.5),
                          blurRadius: 6,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
