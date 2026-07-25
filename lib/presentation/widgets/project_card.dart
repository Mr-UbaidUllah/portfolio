import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final String imagePath;
  final List<String> tags;
  final VoidCallback onLiveDemo;
  final VoidCallback onGitHub;
  final bool isPrivate;
  final bool isFeatured;

  const ProjectCard({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.tags,
    required this.onLiveDemo,
    required this.onGitHub,
    this.isPrivate = false,
    this.isFeatured = false,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  final ValueNotifier<bool> _isHovered = ValueNotifier(false);
  final ValueNotifier<Offset> _mousePos = ValueNotifier(Offset.zero);

  @override
  void dispose() {
    _isHovered.dispose();
    _mousePos.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool reduceMotion = MediaQuery.of(context).accessibleNavigation || 
                             MediaQuery.of(context).disableAnimations;

    return Focus(
      onFocusChange: (focused) => _isHovered.value = focused,
      child: MouseRegion(
        onEnter: (e) => _isHovered.value = true,
        onExit: (e) => _isHovered.value = false,
        onHover: (e) {
          final box = context.findRenderObject() as RenderBox;
          _mousePos.value = box.globalToLocal(e.position);
        },
        cursor: SystemMouseCursors.click,
        child: ValueListenableBuilder2<bool, Offset>(
          first: _isHovered,
          second: _mousePos,
          builder: (context, hovered, mousePos, child) {
            // Tilt calculation for 3D perspective
            final tiltX = hovered && !reduceMotion ? (mousePos.dy - 125) / 125 * -0.05 : 0.0;
            final tiltY = hovered && !reduceMotion ? (mousePos.dx - 200) / 200 * 0.05 : 0.0;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutQuart,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // Perspective
                ..rotateX(tiltX)
                ..rotateY(tiltY)
                ..scale(hovered && !reduceMotion ? 1.02 : 1.0, hovered && !reduceMotion ? 1.02 : 1.0, 1.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: hovered && !reduceMotion
                        ? const Color(0xFF6C63FF).withValues(alpha: 0.25)
                        : Colors.black.withValues(alpha: 0.4),
                    blurRadius: hovered && !reduceMotion ? 40 : 25,
                    offset: Offset(0, hovered && !reduceMotion ? 20 : 12),
                    spreadRadius: hovered && !reduceMotion ? 4 : -2,
                  ),
                ],
              ),
              child: child,
            );
          },
          child: Semantics(
            container: true,
            label: 'Project: ${widget.title}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  // Glassmorphism background
                  ValueListenableBuilder<bool>(
                    valueListenable: _isHovered,
                    builder: (context, hovered, _) {
                      return BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF161629).withValues(alpha: hovered ? 0.85 : 0.7),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: hovered
                                  ? const Color(0xFF6C63FF).withValues(alpha: 0.6)
                                  : Colors.white.withValues(alpha: 0.1),
                              width: 1.5,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // Animated Gradient Border (Internal Glow)
                  if (!reduceMotion)
                    ValueListenableBuilder<bool>(
                      valueListenable: _isHovered,
                      builder: (context, hovered, _) {
                        return hovered ? const Positioned.fill(child: _ShineEffect()) : const SizedBox.shrink();
                      },
                    ),

                  // Content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Section
                      _buildImageSection(reduceMotion),

                      // Details Section
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(),
                            const SizedBox(height: 16),
                            _buildDescription(),
                            const SizedBox(height: 24),
                            _buildTags(reduceMotion),
                            const SizedBox(height: 32),
                            _buildButtons(),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Spotlight effect (Mouse Follow Glow)
                  if (!reduceMotion)
                    ValueListenableBuilder2<bool, Offset>(
                      first: _isHovered,
                      second: _mousePos,
                      builder: (context, hovered, mousePos, _) {
                        if (!hovered) return const SizedBox.shrink();
                        return Positioned(
                          left: mousePos.dx - 150,
                          top: mousePos.dy - 150,
                          child: IgnorePointer(
                            child: Container(
                              width: 300,
                              height: 300,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    const Color(0xFF6C63FF).withValues(alpha: 0.12),
                                    const Color(0xFF6C63FF).withValues(alpha: 0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(bool reduceMotion) {
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: SizedBox(
          height: 250,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Smooth Zoom Effect
              ValueListenableBuilder<bool>(
                valueListenable: _isHovered,
                builder: (context, hovered, _) {
                  return AnimatedScale(
                    scale: hovered && !reduceMotion ? 1.1 : 1.0,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                    child: Image.asset(
                      widget.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.white.withValues(alpha: 0.05),
                        child: const Icon(
                          Icons.image,
                          color: Colors.white24,
                          size: 50,
                        ),
                      ),
                    ),
                  );
                },
              ),
              // Floating Motion / Parallax overlay
              if (!reduceMotion)
                ValueListenableBuilder<bool>(
                  valueListenable: _isHovered,
                  builder: (context, hovered, _) {
                    if (!hovered) return const SizedBox.shrink();
                    return Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withValues(alpha: 0.05),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.1),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
              if (widget.isFeatured)
                Positioned(
                  top: 16,
                  right: 16,
                  child: const _FeaturedBadge(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            // Animated Gradient Line
            ValueListenableBuilder<bool>(
              valueListenable: _isHovered,
              builder: (context, hovered, _) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  height: 2.5,
                  width: hovered ? 80 : 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFF00FF94)],
                    ),
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      if (hovered)
                        BoxShadow(
                          color: const Color(0xFF6C63FF).withValues(alpha: 0.5),
                          blurRadius: 8,
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _isHovered,
          builder: (context, hovered, _) {
            return Icon(
              widget.isPrivate ? Icons.lock_outline : Icons.star_rounded,
              color: const Color(0xFFBEB6FF),
              size: 24,
            ).animate(target: hovered ? 1 : 0).scale(end: const Offset(1.3, 1.3)).shake(hz: 3);
          },
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      widget.description,
      style: TextStyle(
        fontSize: 15,
        color: Colors.white.withValues(alpha: 0.7),
        height: 1.6,
      ),
    );
  }

  Widget _buildTags(bool reduceMotion) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: widget.tags.map((tag) => _TechChip(tag: tag, reduceMotion: reduceMotion)).toList(),
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        Expanded(
          child: _ModernButton(
            text: widget.isPrivate ? 'Private Beta' : 'Live Demo',
            icon: widget.isPrivate ? Icons.lock_outline : Icons.open_in_new,
            onPressed: widget.isPrivate ? null : widget.onLiveDemo,
            isPrimary: true,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _ModernButton(
            text: 'GitHub',
            icon: Icons.code,
            onPressed: widget.onGitHub,
            isPrimary: false,
          ),
        ),
      ],
    );
  }
}

class _ModernButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isPrimary;

  const _ModernButton({
    required this.text,
    required this.icon,
    this.onPressed,
    required this.isPrimary,
  });

  @override
  State<_ModernButton> createState() => _ModernButtonState();
}

class _ModernButtonState extends State<_ModernButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF6C63FF);
    final bool reduceMotion = MediaQuery.of(context).accessibleNavigation || 
                             MediaQuery.of(context).disableAnimations;

    return Focus(
      onFocusChange: (focused) => setState(() => _isHovered = focused),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedScale(
          scale: _isHovered && !reduceMotion ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                if (_isHovered && widget.onPressed != null && !reduceMotion)
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
              ],
            ),
            child: ElevatedButton(
              onPressed: widget.onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.isPrimary
                    ? (widget.onPressed == null ? primaryColor.withValues(alpha: 0.5) : primaryColor)
                    : Colors.transparent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: widget.isPrimary
                      ? (_isHovered ? const BorderSide(color: Colors.white, width: 2) : BorderSide.none)
                      : BorderSide(color: Colors.white.withValues(alpha: _isHovered ? 0.5 : 0.2)),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.text,
                    style: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
                  ),
                  const SizedBox(width: 8),
                  Icon(widget.icon, size: 18)
                      .animate(target: _isHovered && !reduceMotion ? 1 : 0)
                      .moveX(begin: 0, end: 4, duration: const Duration(milliseconds: 200)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TechChip extends StatefulWidget {
  final String tag;
  final bool reduceMotion;
  const _TechChip({required this.tag, required this.reduceMotion});

  @override
  State<_TechChip> createState() => _TechChipState();
}

class _TechChipState extends State<_TechChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focused) => setState(() => _isHovered = focused),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _isHovered ? const Color(0xFF6C63FF).withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isHovered ? const Color(0xFF6C63FF).withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: Text(
            widget.tag,
            style: TextStyle(
              color: _isHovered ? Colors.white : Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
              fontWeight: _isHovered ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ).animate(target: _isHovered && !widget.reduceMotion ? 1 : 0).scale(end: const Offset(1.1, 1.1), duration: const Duration(milliseconds: 200)),
      ),
    );
  }
}

class _ShineEffect extends StatefulWidget {
  const _ShineEffect();

  @override
  State<_ShineEffect> createState() => _ShineEffectState();
}

class _ShineEffectState extends State<_ShineEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(-500 + _controller.value * 1000, -500 + _controller.value * 1000),
            child: Transform.rotate(
              angle: math.pi / 4,
              child: Container(
                width: 100,
                height: 1000,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0),
                      Colors.white.withValues(alpha: 0.08),
                      Colors.white.withValues(alpha: 0),
                    ],
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

class _FeaturedBadge extends StatelessWidget {
  const _FeaturedBadge();

  @override
  Widget build(BuildContext context) {
    final bool reduceMotion = MediaQuery.of(context).accessibleNavigation || 
                             MediaQuery.of(context).disableAnimations;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF00FF94)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome, color: Colors.white, size: 14),
          SizedBox(width: 6),
          Text(
            'FEATURED',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    ).animate(onPlay: (c) => reduceMotion ? c.stop() : c.repeat(reverse: true))
     .shimmer(duration: const Duration(seconds: 2));
  }
}

class ValueListenableBuilder2<A, B> extends StatelessWidget {
  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final Widget Function(BuildContext context, A a, B b, Widget? child) builder;
  final Widget? child;

  const ValueListenableBuilder2({
    super.key,
    required this.first,
    required this.second,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<A>(
        valueListenable: first,
        builder: (context, a, _) => ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (context, b, _) => builder(context, a, b, child),
        ),
      );
}
