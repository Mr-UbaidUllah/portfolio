import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ExperienceItem extends StatefulWidget {
  final String title;
  final String company;
  final String companyLogo;
  final String period;
  final String location;
  final String employmentType;
  final List<String> technologies;
  final List<String> responsibilities;
  final List<String> achievements;
  final bool isLast;
  final bool isFirst;
  final bool isCurrent;

  const ExperienceItem({
    super.key,
    required this.title,
    required this.company,
    this.companyLogo = '',
    required this.period,
    required this.location,
    this.employmentType = 'Full-time',
    this.technologies = const [],
    this.responsibilities = const [],
    this.achievements = const [],
    this.isLast = false,
    this.isFirst = false,
    this.isCurrent = false,
  });

  @override
  State<ExperienceItem> createState() => _ExperienceItemState();
}

class _ExperienceItemState extends State<ExperienceItem> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  Offset _mousePosition = Offset.zero;
  double _rotateX = 0;
  double _rotateY = 0;
  late AnimationController _hoverController;
  final GlobalKey _cardKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _updateTilt(Offset localPosition) {
    final RenderBox? box = _cardKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize) {
      final size = box.size;
      setState(() {
        _rotateX = (localPosition.dy - size.height / 2) / (size.height / 2) * -0.05;
        _rotateY = (localPosition.dx - size.width / 2) / (size.width / 2) * 0.05;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Column
          SizedBox(
            width: 50,
            child: Column(
              children: [
                if (!widget.isFirst)
                  Expanded(
                    child: Container(
                      width: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFF6C63FF).withValues(alpha: 0.1),
                            const Color(0xFF6C63FF),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                _buildTimelineNode(),
                const SizedBox(height: 12),
                if (!widget.isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFF6C63FF),
                            const Color(0xFF6C63FF).withValues(alpha: 0.1),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 32),

          // Content Card
          Expanded(
            child: MouseRegion(
              onEnter: (event) {
                setState(() => _isHovered = true);
                _hoverController.forward();
                _updateTilt(event.localPosition);
              },
              onHover: (event) {
                setState(() => _mousePosition = event.localPosition);
                _updateTilt(event.localPosition);
              },
              onExit: (event) {
                setState(() {
                  _isHovered = false;
                  _rotateX = 0;
                  _rotateY = 0;
                });
                _hoverController.reverse();
              },
              child: AnimatedBuilder(
                animation: _hoverController,
                builder: (context, child) {
                  return Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001) // perspective
                      ..rotateX(_rotateX)
                      ..rotateY(_rotateY)
                      ..translate(_isHovered ? 12.0 : 0.0, _isHovered ? -8.0 : 0.0),
                    alignment: Alignment.center,
                    child: child,
                  );
                },
                child: Stack(
                  key: _cardKey,
                  children: [
                    // Glassmorphism Card
                    Container(
                      margin: const EdgeInsets.only(bottom: 60),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          if (_isHovered)
                            BoxShadow(
                              color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
                              blurRadius: 40,
                              offset: const Offset(0, 20),
                            ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            padding: const EdgeInsets.all(40),
                            decoration: BoxDecoration(
                              color: const Color(0xFF161629).withValues(alpha: _isHovered ? 0.9 : 0.7),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                color: _isHovered
                                    ? const Color(0xFF6C63FF).withValues(alpha: 0.5)
                                    : Colors.white.withValues(alpha: 0.1),
                                width: 1.5,
                              ),
                              gradient: _isHovered
                                  ? LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        const Color(0xFF6C63FF).withValues(alpha: 0.15),
                                        const Color(0xFF6C63FF).withValues(alpha: 0.02),
                                      ],
                                    )
                                  : null,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Top row: Period and Badges
                                Row(
                                  children: [
                                    _buildBadge(widget.period, isPrimary: widget.isCurrent),
                                    const SizedBox(width: 12),
                                    _buildBadge(widget.employmentType),
                                    const Spacer(),
                                    if (widget.isCurrent) _buildCurrentStatus(),
                                  ],
                                ),
                                const SizedBox(height: 32),
                                
                                // Header: Title and Company
                                Row(
                                  children: [
                                    if (widget.companyLogo.isNotEmpty)
                                       Container(
                                         width: 50,
                                         height: 50,
                                         margin: const EdgeInsets.only(right: 16),
                                         decoration: BoxDecoration(
                                           color: Colors.white10,
                                           borderRadius: BorderRadius.circular(12),
                                         ),
                                         child: const Icon(Icons.business, color: Colors.white60, size: 28),
                                       ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.title,
                                            style: const TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
                                              letterSpacing: -1,
                                            ),
                                          ).animate(target: _isHovered ? 1 : 0).shimmer(duration: 2.seconds, color: const Color(0xFFBEB6FF)),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${widget.company} • ${widget.location}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: const Color(0xFFBEB6FF).withValues(alpha: 0.8),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 40),

                                // Technologies (Animated Chips)
                                if (widget.technologies.isNotEmpty) ...[
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: widget.technologies.map((tech) => _buildTechChip(tech)).toList(),
                                  ),
                                  const SizedBox(height: 40),
                                ],

                                // Responsibilities section
                                const Text(
                                  'KEY RESPONSIBILITIES',
                                  style: TextStyle(
                                    color: Colors.white24,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 3,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ...widget.responsibilities.asMap().entries.map(
                                  (entry) => _buildAnimatedBullet(entry.value, entry.key),
                                ),

                                // Achievements section
                                if (widget.achievements.isNotEmpty) ...[
                                  const SizedBox(height: 32),
                                  Text(
                                    'ACHIEVEMENTS & IMPACT',
                                    style: TextStyle(
                                      color: const Color(0xFF00FF94).withValues(alpha: 0.5),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 3,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  ...widget.achievements.asMap().entries.map(
                                    (entry) => _buildAchievementItem(entry.value, entry.key),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Spotlight layer
                    if (_isHovered)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: AnimatedBuilder(
                            animation: _hoverController,
                            builder: (context, child) {
                              return CustomPaint(
                                painter: _SpotlightPainter(
                                  mousePosition: _mousePosition,
                                  color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineNode() {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF02020A),
        border: Border.all(
          color: widget.isCurrent ? const Color(0xFF00FF94) : const Color(0xFF6C63FF),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: (widget.isCurrent ? const Color(0xFF00FF94) : const Color(0xFF6C63FF)).withValues(alpha: 0.5),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: widget.isCurrent ? const Color(0xFF00FF94) : const Color(0xFF6C63FF),
            shape: BoxShape.circle,
          ),
        ),
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
          begin: const Offset(1, 1),
          end: const Offset(1.15, 1.15),
          duration: 1.5.seconds,
          curve: Curves.easeInOut,
        );
  }

  Widget _buildBadge(String text, {bool isPrimary = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isPrimary ? const Color(0xFF6C63FF).withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isPrimary ? const Color(0xFF6C63FF).withValues(alpha: 0.3) : Colors.white10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isPrimary ? const Color(0xFFBEB6FF) : Colors.white70,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildCurrentStatus() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(color: Color(0xFF00FF94), shape: BoxShape.circle),
        ).animate(onPlay: (c) => c.repeat()).scale(duration: 1.2.seconds, end: const Offset(2, 2)).fadeOut(),
        const SizedBox(width: 10),
        const Text(
          'ACTIVE',
          style: TextStyle(color: Color(0xFF00FF94), fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
      ],
    );
  }

  Widget _buildTechChip(String tech) {
    return _AnimatedTechChip(tech: tech);
  }

  Widget _buildAnimatedBullet(String text, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(color: Color(0xFF6C63FF), shape: BoxShape.circle),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                height: 1.6,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (400 + index * 100).ms, duration: 600.ms).slideX(begin: 0.02);
  }

  Widget _buildAchievementItem(String text, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.verified, color: Color(0xFF00FF94), size: 18),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                height: 1.6,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (600 + index * 100).ms, duration: 600.ms).slideX(begin: 0.02);
  }
}

class _AnimatedTechChip extends StatefulWidget {
  final String tech;
  const _AnimatedTechChip({required this.tech});

  @override
  State<_AnimatedTechChip> createState() => _AnimatedTechChipState();
}

class _AnimatedTechChipState extends State<_AnimatedTechChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: _isHovered ? const Color(0xFF6C63FF).withValues(alpha: 0.2) : const Color(0xFF6C63FF).withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isHovered ? const Color(0xFF6C63FF).withValues(alpha: 0.6) : const Color(0xFF6C63FF).withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            if (_isHovered)
               BoxShadow(
                 color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
                 blurRadius: 12,
               ),
          ],
        ),
        child: Text(
          widget.tech,
          style: TextStyle(
            color: _isHovered ? Colors.white : const Color(0xFFBEB6FF),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ).animate(target: _isHovered ? 1 : 0).scale(end: const Offset(1.1, 1.1)),
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  final Offset mousePosition;
  final Color color;

  _SpotlightPainter({required this.mousePosition, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [color, Colors.transparent],
      ).createShader(Rect.fromCircle(center: mousePosition, radius: 300));

    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(_SpotlightPainter oldDelegate) => oldDelegate.mousePosition != mousePosition;
}
