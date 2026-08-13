import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/app_breakpoints.dart';
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

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = AppBreakpoints.isMobile(size.width);
    final cardWidth = isMobile ? size.width * 0.95 : math.min(size.width * 0.9, 1100.0);
    final bool reduceMotion = MediaQuery.of(context).accessibleNavigation || 
                             MediaQuery.of(context).disableAnimations;

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
          if (reduceMotion) return child!;
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
                    color: const Color(0xFF6C63FF).withValues(alpha: hovered && !reduceMotion ? 0.2 : 0.05),
                    blurRadius: 100,
                    spreadRadius: hovered && !reduceMotion ? 20 : 10,
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
              ? Column(
                  children: [
                    _buildImage(isMobile),
                    const SizedBox(height: 48),
                    ..._buildContent(context, isMobile),
                  ],
                )
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
          fontSize: isMobile ? 42 : 72,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.5,
          height: 1.1,
        ),
      ).animate().fadeIn(duration: 800.ms, delay: 200.ms).slideY(begin: 0.2),
      const SizedBox(height: 16),
      _TypewriterText(
        texts: const ['Flutter Developer', 'Full-Stack Developer', 'UI/UX Designer'],
        style: TextStyle(
          color: const Color(0xFFBEB6FF),
          fontSize: isMobile ? 18 : 26,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.5,
        ),
      ).animate().fadeIn(duration: 800.ms, delay: 400.ms),
      const SizedBox(height: 32),
      Text(
        'I build high-performance mobile and web applications with Flutter, backed by clean architecture, modern UI, and scalable technologies.',
        textAlign: isMobile ? TextAlign.center : TextAlign.start,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.7),
          fontSize: isMobile ? 16 : 20,
          height: 1.6,
          fontWeight: FontWeight.w300,
        ),
      ).animate().fadeIn(duration: 800.ms, delay: 600.ms).slideY(begin: 0.1),
      const SizedBox(height: 48),
      isMobile
          ? Column(
              children: [
                _PremiumButton(
                  text: 'View My Projects',
                  isPrimary: true,
                  onPressed: () => context.go('/projects'),
                ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2),
                const SizedBox(height: 16),
                _PremiumButton(
                  text: 'Let\'s Work Together',
                  isPrimary: false,
                  onPressed: () => context.go('/contact'),
                ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.2),
              ],
            )
          : Row(
              children: [
                _PremiumButton(
                  text: 'View My Projects',
                  isPrimary: true,
                  onPressed: () => context.go('/projects'),
                ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2),
                const SizedBox(width: 24),
                _PremiumButton(
                  text: 'Let\'s Work Together',
                  isPrimary: false,
                  onPressed: () => context.go('/contact'),
                ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.2),
              ],
            ),
      const SizedBox(height: 40),
      _buildSocialLinks(isMobile),
    ];
  }

  Widget _buildSocialLinks(bool isMobile) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
      children: [
        _SocialLinkIcon(
          icon: Icons.link,
          label: 'LinkedIn',
          onTap: () => _launchUrl('https://www.linkedin.com/in/ubaid-ullah'),
        ),
        _SocialLinkIcon(
          icon: Icons.code,
          label: 'GitHub',
          onTap: () => _launchUrl('https://github.com/Mr-UbaidUllah'),
        ),
        _SocialLinkIcon(
          icon: Icons.alternate_email,
          label: 'Email',
          onTap: () => _launchUrl('mailto:ubaidullah.dev09@gmail.com'),
        ),
      ].animate(interval: 100.ms).fadeIn(delay: 1.2.seconds).slideY(begin: 0.2),
    );
  }

  Widget _buildImage(bool isMobile) {
    final bool reduceMotion = MediaQuery.of(context).accessibleNavigation || 
                             MediaQuery.of(context).disableAnimations;
    final imageSize = isMobile ? 220.0 : 380.0;

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          if (reduceMotion) return child!;
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
              if (!isMobile && !reduceMotion) ...[
                const _OrbitingIcon(icon: Icons.flutter_dash, angle: 0, color: Color(0xFF02539A)),
                const _OrbitingIcon(icon: Icons.code, angle: 72, color: Color(0xFF6C63FF)),
                const _OrbitingIcon(icon: Icons.design_services, angle: 144, color: Color(0xFFBEB6FF)),
                const _OrbitingIcon(icon: Icons.storage, angle: 216, color: Color(0xFF00FF94)),
                const _OrbitingIcon(icon: Icons.bolt, angle: 288, color: Colors.yellow),
              ],
      
              ...List.generate(2, (index) => 
                Container(
                  width: imageSize + (index * 40),
                  height: imageSize + (index * 40),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF6C63FF).withValues(alpha: 0.2 / (index + 1)),
                      width: 2,
                    ),
                  ),
                )
                .animate(onPlay: (c) => reduceMotion ? c.stop() : c.repeat())
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
                  child: Semantics(
                    label: 'Profile image of Ubaid Ullah',
                    child: Image.asset(
                      'assets/images/profileImage.png',
                      height: isMobile ? 280 : 480,
                      width: isMobile ? 220 : 380,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: isMobile ? 280 : 480,
                        width: isMobile ? 220 : 380,
                        color: Colors.white10,
                        child: const Icon(Icons.person, size: 80),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 1.seconds, delay: 400.ms).scale(begin: const Offset(0.8, 0.8)),
    );
  }
}

class _SocialLinkIcon extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialLinkIcon({required this.icon, required this.label, required this.onTap});

  @override
  State<_SocialLinkIcon> createState() => _SocialLinkIconState();
}

class _SocialLinkIconState extends State<_SocialLinkIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.label,
      child: Focus(
        onFocusChange: (focused) => setState(() => _isHovered = focused),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: Semantics(
            button: true,
            label: 'Link to ${widget.label}',
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _isHovered ? const Color(0xFF6C63FF).withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isHovered ? const Color(0xFF6C63FF).withValues(alpha: 0.5) : Colors.white10,
                  ),
                ),
                child: Icon(
                  widget.icon,
                  color: _isHovered ? Colors.white : Colors.white38,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
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
    final bool reduceMotion = MediaQuery.of(context).accessibleNavigation || 
                             MediaQuery.of(context).disableAnimations;
    if (reduceMotion) return Text(widget.text, style: widget.style.copyWith(color: Colors.white));

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
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _type());
  }

  void _type() {
    if (!mounted) return;
    final bool reduceMotion = MediaQuery.of(context).accessibleNavigation || 
                             MediaQuery.of(context).disableAnimations;
    
    if (reduceMotion) {
      setState(() {
        _charIndex = widget.texts[_textIndex].length;
      });
      return;
    }

    final currentText = widget.texts[_textIndex];
    setState(() {
      if (_isDeleting) {
        _charIndex--;
      } else {
        _charIndex++;
      }
    });

    Duration delay = const Duration(milliseconds: 100);
    
    if (!_isDeleting && _charIndex == currentText.length) {
      delay = const Duration(seconds: 2);
      _isDeleting = true;
    } else if (_isDeleting && _charIndex == 0) {
      _isDeleting = false;
      _textIndex = (_textIndex + 1) % widget.texts.length;
      delay = const Duration(milliseconds: 500);
    } else if (_isDeleting) {
      delay = const Duration(milliseconds: 50);
    }

    _timer = Timer(delay, _type);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Rotating roles: ${widget.texts[_textIndex]}',
      child: Text(
        '${widget.texts[_textIndex].substring(0, _charIndex)}_',
        style: widget.style,
      ),
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
            height: 60,
            width: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: _isHovered && widget.isPrimary && !reduceMotion
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
                  side: widget.isPrimary 
                    ? (_isHovered ? const BorderSide(color: Colors.white, width: 2) : BorderSide.none)
                    : BorderSide(color: _isHovered ? const Color(0xFF6C63FF) : Colors.white24, width: 1.5),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (widget.isPrimary && _isHovered && !reduceMotion)
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
                            .animate(target: _isHovered && !reduceMotion ? 1 : 0)
                            .moveX(begin: 0, end: 5),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
