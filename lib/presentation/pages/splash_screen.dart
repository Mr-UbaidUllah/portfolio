import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../widgets/grid_painter.dart';
import '../widgets/terminal_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  final ValueNotifier<Offset> _mousePosition = ValueNotifier(Offset.zero);
  bool _startTransition = false;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _startNavigationTimer();
  }

  void _startNavigationTimer() {
    _navigationTimer = Timer(const Duration(milliseconds: 2500), () {
      _goToHome();
    });
  }

  void _goToHome() {
    if (_startTransition) return;
    if (mounted) {
      setState(() => _startTransition = true);
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          context.go('/home');
        }
      });
    }
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _mousePosition.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF02020A),
      body: Focus(
        autofocus: true,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent && 
              (event.logicalKey == LogicalKeyboardKey.enter || 
               event.logicalKey == LogicalKeyboardKey.space)) {
            _goToHome();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: GestureDetector(
          onTap: _goToHome,
          behavior: HitTestBehavior.opaque,
          child: MouseRegion(
            onHover: (event) => _mousePosition.value = event.position,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 600),
              opacity: _startTransition ? 0 : 1,
              child: Stack(
                children: [
                  // 1. Background Layer: Dark & Ambient
                  const _SplashBackground(),

                  // 2. Interactive Cursor Glow (Desktop)
                  ValueListenableBuilder<Offset>(
                    valueListenable: _mousePosition,
                    builder: (context, position, child) {
                      return Positioned(
                        left: position.dx - 200,
                        top: position.dy - 200,
                        child: IgnorePointer(
                          child: Container(
                            width: 400,
                            height: 400,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  const Color(0xFF6366F1).withValues(alpha: 0.05),
                                  const Color(0xFF6366F1).withValues(alpha: 0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // 3. Subtle Code/Terminal Background
                  Center(
                    child: RepaintBoundary(
                      child: Opacity(
                        opacity: 0.1,
                        child: Transform.scale(
                          scale: 1.3,
                          child: const TerminalWidget(),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(duration: 2.seconds, delay: 500.ms),

                  // 4. Main Content: Logo, Name, Roles
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Premium Logo
                        const _PremiumLogo(),
                        const SizedBox(height: 60),

                        // Name with Character Reveal
                        const _AnimatedName(name: 'Ubaid Ullah'),
                        const SizedBox(height: 16),

                        // Role Typewriter
                        const _RoleTypewriter(),
                      ],
                    ),
                  ),

                  // Floating Dev Elements
                  ..._buildFloatingElements(),

                  //Premium Circular Loader
                  Positioned(
                    bottom: 80,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: const _PremiumCircularLoader(),
                    ),
                  ),

                  // Skip Hint
                  Positioned(
                    bottom: 30,
                    right: 30,
                    child: Text(
                      'Press SPACE to skip',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.3),
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ).animate().fadeIn(delay: 1.seconds),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFloatingElements() {
    final elements = [
      Icons.flutter_dash,
      Icons.code_rounded,
      Icons.layers_outlined,
      Icons.terminal_rounded,
      Icons.api_rounded,
      Icons.smartphone_rounded,
    ];

    return List.generate(elements.length, (index) {
      return Positioned(
        top: 150.0 + (index * 140),
        left: (index % 2 == 0) ? 80 : null,
        right: (index % 2 != 0) ? 80 : null,
        child: RepaintBoundary(
          child: Icon(
            elements[index],
            color: Colors.white.withValues(alpha: 0.04),
            size: 44,
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveY(begin: 0, end: 30, duration: (3 + index).seconds, curve: Curves.easeInOut)
              .rotate(begin: -0.1, end: 0.1, duration: (4 + index).seconds),
        ),
      );
    });
  }
}

class _PremiumLogo extends StatelessWidget {
  const _PremiumLogo();

  @override
  Widget build(BuildContext context) {
    final bool reduceMotion = MediaQuery.of(context).accessibleNavigation || 
                             MediaQuery.of(context).disableAnimations;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer Glowing Ring
        if (!reduceMotion)
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                width: 1,
              ),
            ),
          ).animate(onPlay: (c) => c.repeat())
              .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.3, 1.3), duration: 3.seconds)
              .fadeOut(duration: 3.seconds),

        // Middle Pulsing Ring
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF00FF94).withValues(alpha: 0.2),
              width: 2,
            ),
          ),
        ).animate(onPlay: (c) => reduceMotion ? c.stop() : c.repeat(reverse: true))
            .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 2.seconds, curve: Curves.easeInOut),

        // Main Glassmorphism Logo
        ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(35),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Text(
                'UU',
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -3,
                ),
              ),
            ),
          ),
        )
            .animate()
            .scale(begin: const Offset(0, 0), end: const Offset(1, 1), duration: reduceMotion ? 400.ms : 1.seconds, curve: Curves.easeOutBack)
            .fadeIn(duration: 800.ms)
            .shimmer(delay: 2.seconds, duration: 2.seconds, color: const Color(0xFF00FF94)),
      ],
    ).animate(onPlay: (c) => reduceMotion ? c.stop() : c.repeat(reverse: true))
        .moveY(begin: -8, end: 8, duration: 4.seconds, curve: Curves.easeInOut);
  }
}

class _AnimatedName extends StatelessWidget {
  final String name;
  const _AnimatedName({required this.name});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Portfolio of $name',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: name.split('').asMap().entries.map((entry) {
          return Text(
            entry.value,
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ).animate()
              .fadeIn(delay: (1000 + (entry.key * 50)).ms, duration: 400.ms)
              .slideY(begin: 0.5, end: 0, delay: (1000 + (entry.key * 50)).ms, duration: 600.ms, curve: Curves.easeOutCubic);
        }).toList(),
      ),
    ).animate().shimmer(delay: 3.seconds, duration: 2.seconds, color: const Color(0xFF6366F1));
  }
}

class _RoleTypewriter extends StatefulWidget {
  const _RoleTypewriter();

  @override
  State<_RoleTypewriter> createState() => _RoleTypewriterState();
}

class _RoleTypewriterState extends State<_RoleTypewriter> {
  final List<String> _roles = [
    'Flutter Developer',
    'Full Stack Developer',
    'UI/UX Designer',
    'Mobile App Developer',
  ];
  int _roleIndex = 0;
  int _charIndex = 0;
  bool _isDeleting = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), _type);
  }

  void _type() {
    if (!mounted) return;
    
    final currentRole = _roles[_roleIndex];
    
    setState(() {
      if (_isDeleting) {
        _charIndex--;
      } else {
        _charIndex++;
      }
    });

    Duration delay = const Duration(milliseconds: 50);
    
    if (!_isDeleting && _charIndex == currentRole.length) {
      delay = const Duration(seconds: 1);
      _isDeleting = true;
    } else if (_isDeleting && _charIndex == 0) {
      _isDeleting = false;
      _roleIndex = (_roleIndex + 1) % _roles.length;
      delay = const Duration(milliseconds: 300);
    } else if (_isDeleting) {
      delay = const Duration(milliseconds: 25);
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
    return SizedBox(
      height: 30,
      child: Semantics(
        label: 'Current role: ${_roles[_roleIndex]}',
        child: Text(
          '${_roles[_roleIndex].substring(0, _charIndex)}|',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white.withValues(alpha: 0.5),
            letterSpacing: 4,
            fontFamily: 'monospace',
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}

class _PremiumCircularLoader extends StatefulWidget {
  const _PremiumCircularLoader();

  @override
  State<_PremiumCircularLoader> createState() => _PremiumCircularLoaderState();
}

class _PremiumCircularLoaderState extends State<_PremiumCircularLoader> with SingleTickerProviderStateMixin {
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * 3.14159,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white10, width: 2),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 25 - 4,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF6366F1),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Color(0xFF6366F1), blurRadius: 10, spreadRadius: 2),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).animate().fadeIn(delay: 1.seconds);
  }
}

class _SplashBackground extends StatelessWidget {
  const _SplashBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Grid Pattern
        Opacity(
          opacity: 0.1,
          child: RepaintBoundary(
            child: CustomPaint(
              size: Size.infinite,
              painter: GridPainter(),
            ),
          ),
        ),

        // Aurora Blobs
        Positioned(
          top: -150,
          left: -150,
          child: _AuroraBlob(
            color: const Color(0xFF6366F1).withValues(alpha: 0.12),
            size: 600,
          ),
        ).animate(onPlay: (c) => c.repeat(reverse: true)).move(begin: const Offset(-30, -30), end: const Offset(30, 30), duration: 10.seconds),

        Positioned(
          bottom: -200,
          right: -100,
          child: _AuroraBlob(
            color: const Color(0xFF00FF94).withValues(alpha: 0.08),
            size: 700,
          ),
        ).animate(onPlay: (c) => c.repeat(reverse: true)).move(begin: const Offset(40, 40), end: const Offset(-40, -40), duration: 12.seconds),

        // Subtle Particles
        const _FloatingParticles(),
      ],
    );
  }
}

class _AuroraBlob extends StatelessWidget {
  final Color color;
  final double size;

  const _AuroraBlob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}

class _FloatingParticles extends StatelessWidget {
  const _FloatingParticles();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(30, (index) {
        return Positioned(
          top: (index * 97.5) % 900,
          left: (index * 153.7) % 1400,
          child: RepaintBoundary(
            child: Container(
              width: 1.5,
              height: 1.5,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                shape: BoxShape.circle,
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(duration: (2 + (index % 4)).seconds).scale(begin: const Offset(0.5, 0.5), end: const Offset(2, 2)),
          ),
        );
      }),
    );
  }
}
