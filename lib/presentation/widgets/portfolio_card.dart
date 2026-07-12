import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../pages/contact_page.dart';
import '../pages/projects_page.dart';
import 'available_badge.dart';

class PortfolioCard extends StatefulWidget {
  const PortfolioCard({super.key});

  @override
  State<PortfolioCard> createState() => _PortfolioCardState();
}

class _PortfolioCardState extends State<PortfolioCard> with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  final ValueNotifier<Offset> _tiltOffset = ValueNotifier(Offset.zero);
  final ValueNotifier<bool> _isHovered = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    _tiltOffset.dispose();
    _isHovered.dispose();
    super.dispose();
  }

  void _onMouseMove(PointerEvent details, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    _tiltOffset.value = Offset(
      (details.localPosition.dx - center.dx) / (size.width / 2),
      (details.localPosition.dy - center.dy) / (size.height / 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 800;
    final cardWidth = isMobile ? size.width * 0.9 : 1100.0;

    return MouseRegion(
      onEnter: (_) => _isHovered.value = true,
      onExit: (_) {
        _isHovered.value = false;
        _tiltOffset.value = Offset.zero;
      },
      onHover: (event) => _onMouseMove(event, Size(cardWidth, 600)),
      child: ValueListenableBuilder<Offset>(
        valueListenable: _tiltOffset,
        builder: (context, tilt, child) {
          return TweenAnimationBuilder<Offset>(
            duration: const Duration(milliseconds: 200),
            tween: Tween(begin: Offset.zero, end: tilt),
            builder: (context, animatedTilt, child) {
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(-animatedTilt.dy * 0.05)
                  ..rotateY(animatedTilt.dx * 0.05),
                alignment: Alignment.center,
                child: child,
              );
            },
            child: child,
          );
        },
        child: ValueListenableBuilder<bool>(
          valueListenable: _isHovered,
          builder: (context, hovered, child) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: cardWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withValues(alpha: hovered ? 0.2 : 0.05),
                    blurRadius: 100,
                    spreadRadius: hovered ? 20 : 10,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: EdgeInsets.all(isMobile ? 32 : 64),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D0D1E).withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: hovered ? const Color(0xFF6C63FF).withValues(alpha: 0.5) : Colors.white10,
                        width: 1.5,
                      ),
                    ),
                    child: child,
                  ),
                ),
              ),
            );
          },
          child: isMobile
              ? Column(children: _buildContent(context, isMobile))
              : Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildContent(context, isMobile),
                      ),
                    ),
                    const SizedBox(width: 40),
                    Expanded(flex: 2, child: _buildImage(isMobile)),
                  ],
                ),
        ),
      ),
    );
  }

  List<Widget> _buildContent(BuildContext context, bool isMobile) {
    return [
      const AvailableBadge()
          .animate()
          .fadeIn(duration: 600.ms)
          .slideX(begin: -0.2, curve: Curves.easeOutCubic),
      const SizedBox(height: 32),
      _AnimatedGradientText(
        text: 'Ubaid Ullah',
        style: TextStyle(
          fontSize: isMobile ? 40 : 72,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.5,
        ),
      ).animate().fadeIn(duration: 800.ms, delay: 200.ms).slideY(begin: 0.2),
      const SizedBox(height: 16),
      _TypewriterText(
        texts: const ['Flutter Developer', 'Full Stack Developer', 'UI/UX Designer'],
        style: TextStyle(
          color: const Color(0xFFBEB6FF),
          fontSize: isMobile ? 18 : 26,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.5,
        ),
      ).animate().fadeIn(duration: 800.ms, delay: 400.ms),
      const SizedBox(height: 32),
      Text(
        'Crafting seamless cross-platform mobile experiences with pixel-perfect design and robust backend integration.',
        textAlign: isMobile ? TextAlign.center : TextAlign.start,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.6),
          fontSize: isMobile ? 16 : 20,
          height: 1.6,
          fontWeight: FontWeight.w300,
        ),
      ).animate().fadeIn(duration: 800.ms, delay: 600.ms).slideY(begin: 0.1),
      const SizedBox(height: 56),
      isMobile
          ? Column(children: _buildButtons(context))
          : Row(
              children: _buildButtons(context)
                  .expand((w) => [w, const SizedBox(width: 24)])
                  .toList()
                ..removeLast(),
            ),
      if (isMobile) ...[const SizedBox(height: 56), _buildImage(isMobile)],
    ];
  }

  List<Widget> _buildButtons(BuildContext context) {
    return [
      _PremiumButton(
        text: 'View Projects',
        isPrimary: true,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProjectsPage()),
          );
        },
      ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2),
      _PremiumButton(
        text: 'Contact Me',
        isPrimary: false,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ContactPage()),
          );
        },
      ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.2),
    ];
  }

  Widget _buildImage(bool isMobile) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 15 * math.sin(_floatController.value * 2 * math.pi)),
          child: child,
        );
      },
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Orbiting Icons
            if (!isMobile) ...[
              const _OrbitingIcon(icon: Icons.flutter_dash, angle: 0, color: Color(0xFF02539A)),
              const _OrbitingIcon(icon: Icons.code, angle: 72, color: Color(0xFF6C63FF)),
              const _OrbitingIcon(icon: Icons.design_services, angle: 144, color: Color(0xFFBEB6FF)),
              const _OrbitingIcon(icon: Icons.storage, angle: 216, color: Color(0xFF00FF94)),
              const _OrbitingIcon(icon: Icons.bolt, angle: 288, color: Colors.yellow),
            ],

            // Animated glowing rings
            ...List.generate(2, (index) => 
              Container(
                width: (isMobile ? 240 : 380) + (index * 40),
                height: (isMobile ? 240 : 380) + (index * 40),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF6C63FF).withValues(alpha: 0.2 / (index + 1)),
                    width: 2,
                  ),
                ),
              )
              .animate(onPlay: (c) => c.repeat())
              .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: (2 + index).seconds, curve: Curves.easeInOut)
              .fadeOut(duration: (2 + index).seconds),
            ),
            
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
                    blurRadius: 60,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.asset(
                  'assets/images/profileImage.png',
                  height: isMobile ? 300 : 480,
                  width: isMobile ? 240 : 380,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 1.seconds, delay: 400.ms).scale(begin: const Offset(0.8, 0.8));
  }
}

class _OrbitingIcon extends StatelessWidget {
  final IconData icon;
  final double angle;
  final Color color;

  const _OrbitingIcon({required this.icon, required this.angle, required this.color});

  @override
  Widget build(BuildContext context) {
    return Animate(
      onPlay: (controller) => controller.repeat(),
    ).custom(
      duration: 20.seconds,
      builder: (context, value, child) {
        final currentAngle = (angle * math.pi / 180) + (value * 2 * math.pi);
        const radius = 240.0;
        return Transform.translate(
          offset: Offset(radius * math.cos(currentAngle), radius * math.sin(currentAngle)),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0D0D1E).withValues(alpha: 0.8),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 10, spreadRadius: 2),
              ],
            ),
            child: Icon(icon, color: color, size: 24),
          ),
        );
      },
    );
  }
}

class _AnimatedGradientText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const _AnimatedGradientText({required this.text, required this.style});

  @override
  State<_AnimatedGradientText> createState() => _AnimatedGradientTextState();
}

class _AnimatedGradientTextState extends State<_AnimatedGradientText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: const [Color(0xFFFFFFFF), Color(0xFF6C63FF), Color(0xFF00FF94), Color(0xFFFFFFFF)],
              stops: [
                _controller.value - 0.2,
                _controller.value,
                _controller.value + 0.2,
                _controller.value + 0.4,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          child: Text(widget.text, style: widget.style.copyWith(color: Colors.white)),
        );
      },
    );
  }
}

class _TypewriterText extends StatefulWidget {
  final List<String> texts;
  final TextStyle style;

  const _TypewriterText({required this.texts, required this.style});

  @override
  State<_TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<_TypewriterText> {
  int _textIndex = 0;
  int _charIndex = 0;
  bool _isDeleting = false;
  late Duration _typingSpeed;

  @override
  void initState() {
    super.initState();
    _typingSpeed = const Duration(milliseconds: 100);
    _type();
  }

  void _type() {
    if (!mounted) return;
    final currentText = widget.texts[_textIndex];
    setState(() {
      if (_isDeleting) {
        _charIndex--;
        _typingSpeed = const Duration(milliseconds: 50);
      } else {
        _charIndex++;
        _typingSpeed = const Duration(milliseconds: 100);
      }
    });
    if (!_isDeleting && _charIndex == currentText.length) {
      _isDeleting = true;
      _typingSpeed = const Duration(seconds: 2);
    } else if (_isDeleting && _charIndex == 0) {
      _isDeleting = false;
      _textIndex = (_textIndex + 1) % widget.texts.length;
      _typingSpeed = const Duration(milliseconds: 500);
    }
    Future.delayed(_typingSpeed, _type);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${widget.texts[_textIndex].substring(0, _charIndex)}_',
      style: widget.style,
    );
  }
}

class _PremiumButton extends StatefulWidget {
  final String text;
  final bool isPrimary;
  final VoidCallback onPressed;

  const _PremiumButton({
    required this.text,
    required this.isPrimary,
    required this.onPressed,
  });

  @override
  State<_PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<_PremiumButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          height: 60,
          width: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: _isHovered && widget.isPrimary
                ? [
                    BoxShadow(
                      color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    )
                  ]
                : [],
          ),
          child: ElevatedButton(
            onPressed: widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.isPrimary ? const Color(0xFF6C63FF) : Colors.transparent,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: widget.isPrimary ? BorderSide.none : const BorderSide(color: Colors.white24, width: 1.5),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (widget.isPrimary && _isHovered)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0),
                            Colors.white.withValues(alpha: 0.2),
                            Colors.white.withValues(alpha: 0),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1.5.seconds),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.text,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 0.5),
                    ),
                    if (widget.isPrimary) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 20)
                          .animate(target: _isHovered ? 1 : 0)
                          .moveX(begin: 0, end: 5),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
