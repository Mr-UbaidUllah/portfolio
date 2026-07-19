import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/portfolio_card.dart';
import '../widgets/footer.dart';
import '../widgets/grid_painter.dart';
import '../widgets/terminal_widget.dart';
import 'projects_page.dart';
import 'experience_page.dart';
import 'skills_page.dart';
import 'contact_page.dart';

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key});

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _scrollProgress = ValueNotifier(0.0);
  final ValueNotifier<Offset> _mousePosition = ValueNotifier(Offset.zero);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        _scrollProgress.value = (_scrollController.offset /
                (_scrollController.position.maxScrollExtent > 0
                    ? _scrollController.position.maxScrollExtent
                    : 1.0))
            .clamp(0.0, 1.0);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollProgress.dispose();
    _mousePosition.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 800;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF02020A),
      drawer: isMobile ? const CustomDrawer() : null,
      body: MouseRegion(
        onHover: (event) => _mousePosition.value = event.position,
        child: Stack(
          children: [
            // Background Effects
            const _BackgroundEffects(),
            
            // Interactive Cursor Glow
            if (!isMobile)
              Positioned(
                left: 0,
                top: 0,
                child: IgnorePointer(
                  child: ValueListenableBuilder<Offset>(
                    valueListenable: _mousePosition,
                    builder: (context, position, child) {
                      return Transform.translate(
                        offset: position - const Offset(250, 250),
                        child: child,
                      );
                    },
                    child: Container(
                      width: 500,
                      height: 500,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF6C63FF).withValues(alpha: 0.06),
                            const Color(0xFF6C63FF).withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // Content
            CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Glassmorphism Navbar
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  expandedHeight: 80,
                  collapsedHeight: 70,
                  flexibleSpace: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF02020A).withValues(alpha: 0.7),
                          border: const Border(
                            bottom: BorderSide(color: Colors.white10, width: 0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  leading: isMobile
                      ? IconButton(
                          icon: const Icon(Icons.menu, color: Color(0xFF6C63FF)),
                          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                        )
                      : null,
                  title: Padding(
                    padding: EdgeInsets.only(left: isMobile ? 0 : 40),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF00FF94),
                            shape: BoxShape.circle,
                          ),
                        ).animate(onPlay: (c) => c.repeat()).scale(begin: const Offset(1,1), end: const Offset(2,2), duration: 1.seconds).fadeOut(),
                        const SizedBox(width: 12),
                        const Text(
                          'UBAID',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            letterSpacing: 2,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ).animate().fadeIn(duration: 800.ms).slideX(begin: -0.2),
                  ),
                  actions: [
                    if (!isMobile) ...[
                      _navItem('Home', isSelected: true),
                      _navItem('Projects', destination: const ProjectsPage()),
                      _navItem('Experience', destination: const ExperiencePage()),
                      _navItem('Skills', destination: const SkillsPage()),
                      _navItem('Contact', destination: const ContactPage()),
                      const SizedBox(width: 40),
                    ],
                  ],
                ),

                // Main Content
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 80),
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1200),
                          child: const PortfolioCard(),
                        ),
                      ).animate().fadeIn(duration: 1.2.seconds).scale(begin: const Offset(0.95, 0.95), curve: Curves.easeOutCubic),
                      
                      const SizedBox(height: 100),
                      
                      // Terminal Section
                      if (!isMobile)
                        const TerminalWidget()
                            .animate()
                            .fadeIn(duration: 1.seconds, delay: 1.2.seconds)
                            .slideY(begin: 0.2),

                      const SizedBox(height: 80),
                      
                      // Scroll Down Indicator
                      const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white24, size: 32)
                          .animate(onPlay: (c) => c.repeat())
                          .moveY(begin: 0, end: 10, duration: 1.seconds, curve: Curves.easeInOut)
                          .fadeIn(),

                      const SizedBox(height: 120),
                      const Footer().animate().fadeIn(delay: 600.ms),
                    ],
                  ),
                ),
              ],
            ),

            // Scroll Progress Indicator
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ValueListenableBuilder<double>(
                valueListenable: _scrollProgress,
                builder: (context, progress, child) {
                  return Container(
                    height: 3,
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF6C63FF), Color(0xFF00FF94)],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(String title, {Widget? destination, bool isSelected = false}) {
    return _AnimatedNavItem(title: title, isSelected: isSelected, destination: destination);
  }
}

class _AnimatedNavItem extends StatefulWidget {
  final String title;
  final bool isSelected;
  final Widget? destination;

  const _AnimatedNavItem({required this.title, this.isSelected = false, this.destination});

  @override
  State<_AnimatedNavItem> createState() => _AnimatedNavItemState();
}

class _AnimatedNavItemState extends State<_AnimatedNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: TextButton(
        onPressed: widget.isSelected || widget.destination == null
            ? null
            : () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => widget.destination!)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      BoxShadow(color: const Color(0xFF6C63FF).withValues(alpha: 0.5), blurRadius: 6),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackgroundEffects extends StatelessWidget {
  const _BackgroundEffects();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dark Base
        Container(color: const Color(0xFF02020A)),
        
        // Grid Pattern
        CustomPaint(
          size: Size.infinite,
          painter: GridPainter(),
        ),

        // Animated Mesh Orbs
        Positioned(
          top: -100,
          right: -100,
          child: _BlurredOrb(color: const Color(0xFF6C63FF).withValues(alpha: 0.12), size: 600),
        ).animate(onPlay: (c) => c.repeat(reverse: true)).move(begin: Offset.zero, end: const Offset(-80, 80), duration: 12.seconds, curve: Curves.easeInOut),
        
        Positioned(
          bottom: -150,
          left: -100,
          child: _BlurredOrb(color: const Color(0xFF00FF94).withValues(alpha: 0.08), size: 700),
        ).animate(onPlay: (c) => c.repeat(reverse: true)).move(begin: Offset.zero, end: const Offset(80, -80), duration: 18.seconds, curve: Curves.easeInOut),

        // Floating particles
        ...List.generate(20, (index) => _FloatingParticle(index: index)),
      ],
    );
  }
}

class _BlurredOrb extends StatelessWidget {
  final Color color;
  final double size;

  const _BlurredOrb({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
        ),
      ),
    );
  }
}

class _FloatingParticle extends StatelessWidget {
  final int index;
  const _FloatingParticle({required this.index});

  @override
  Widget build(BuildContext context) {
    final random = math.Random(index);
    final size = random.nextDouble() * 2 + 1;
    final top = random.nextDouble() * 100;
    final left = random.nextDouble() * 100;

    return Positioned(
      top: top * MediaQuery.of(context).size.height / 100,
      left: left * MediaQuery.of(context).size.width / 100,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
      )
      .animate(onPlay: (c) => c.repeat(reverse: true))
      .moveY(end: -30 - random.nextDouble() * 40, duration: (7 + random.nextInt(7)).seconds)
      .fadeIn(duration: 2.seconds)
      .fadeOut(delay: 4.seconds, duration: 2.seconds),
    );
  }
}
