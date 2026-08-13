import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_breakpoints.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/portfolio_card.dart';
import '../widgets/footer.dart';
import '../widgets/grid_painter.dart';
import '../widgets/terminal_widget.dart';
import '../widgets/portfolio_navbar.dart';
import '../widgets/project_card.dart';

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
    final isMobile = AppBreakpoints.isMobile(size.width);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF02020A),
      drawer: isMobile ? const CustomDrawer() : null,
      body: MouseRegion(
        onHover: (event) => _mousePosition.value = event.position,
        child: Stack(
          children: [
            const RepaintBoundary(child: _BackgroundEffects()),
            
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

            CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                PortfolioNavbar(isMobile: isMobile, scaffoldKey: _scaffoldKey),

                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                      
                      // 1. Hero Section - Optimized Primary Focus
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1200),
                          child: const PortfolioCard(),
                        ),
                      ).animate().fadeIn(duration: 1.2.seconds).scale(begin: const Offset(0.95, 0.95), curve: Curves.easeOutCubic),
                      
                      const SizedBox(height: 80),

                      // 2. Quick Credibility Stats
                      const _StatsSection(),

                      const SizedBox(height: 100),

                      // 3. Technology Stack Preview - Concise Built With
                      const _TechStackPreview(),

                      const SizedBox(height: 100),
                      
                      // Terminal Widget - Secondary Credibility
                      if (!isMobile)
                        const TerminalWidget()
                            .animate()
                            .fadeIn(duration: 1.seconds)
                            .slideY(begin: 0.1),

                      const SizedBox(height: 120),

                      // 4. Featured Projects Preview (2-3 Strongest)
                      const _FeaturedProjectsPreview(),

                      const SizedBox(height: 120),

                      // 5. About Me Preview - Concise Teaser
                      const _AboutPreview(),

                      const SizedBox(height: 120),

                      // 6. Final CTA
                      const _FinalCTASection(),

                      const SizedBox(height: 120),
                      const Footer().animate().fadeIn(delay: 400.ms),
                    ],
                  ),
                ),
              ],
            ),

            // Scroll Progress
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
}

class _StatsSection extends StatelessWidget {
  const _StatsSection();

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(MediaQuery.of(context).size.width);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Wrap(
          spacing: isMobile ? 32 : 60,
          runSpacing: 32,
          alignment: WrapAlignment.center,
          children: [
            _buildStat('10+', 'Mobile Apps'),
            _buildStat('Flutter', 'Primary Framework'),
            _buildStat('Full-Stack', 'Development'),
            _buildStat('UI/UX', 'Design Focus'),
          ].animate(interval: 100.ms).fadeIn(duration: 600.ms).slideY(begin: 0.2),
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white.withValues(alpha: 0.4),
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

class _TechStackPreview extends StatelessWidget {
  const _TechStackPreview();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'BUILT WITH',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF6C63FF),
            letterSpacing: 4,
          ),
        ).animate().fadeIn(),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              _TechIcon(icon: Icons.flutter_dash, label: 'Flutter', color: const Color(0xFF02539A)),
              _TechIcon(icon: Icons.code, label: 'Dart', color: const Color(0xFF0175C2)),
              _TechIcon(icon: Icons.storage, label: 'Firebase', color: const Color(0xFFFFCA28)),
              _TechIcon(icon: Icons.dns, label: 'Node.js', color: const Color(0xFF339933)),
              _TechIcon(icon: Icons.terminal, label: 'TypeScript', color: const Color(0xFF3178C6)),
              _TechIcon(icon: Icons.dataset, label: 'MySQL', color: const Color(0xFF4479A1)),
            ].animate(interval: 80.ms).fadeIn(duration: 500.ms).scale(begin: const Offset(0.8, 0.8)),
          ),
        ),
      ],
    );
  }
}

class _TechIcon extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _TechIcon({required this.icon, required this.label, required this.color});

  @override
  State<_TechIcon> createState() => _TechIconState();
}

class _TechIconState extends State<_TechIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.label,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _isHovered ? widget.color.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered ? widget.color.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.05),
              width: 1.5,
            ),
          ),
          child: Icon(widget.icon, color: _isHovered ? widget.color : Colors.white38, size: 28),
        ),
      ),
    );
  }
}

class _FeaturedProjectsPreview extends StatelessWidget {
  const _FeaturedProjectsPreview();

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(MediaQuery.of(context).size.width);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SELECTED WORKS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF00FF94),
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Featured Projects',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                if (!isMobile)
                  TextButton.icon(
                    onPressed: () => context.go('/projects'),
                    icon: const Text('View All Projects'),
                    label: const Icon(Icons.arrow_forward, size: 16),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFBEB6FF),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 48),
            if (isMobile)
              Column(
                children: [
                  _buildFeaturedProject(
                    'Fit Mind',
                    'Health & activity tracker with real-time biometric charts.',
                    ['Flutter', 'Firebase', 'Provider'],
                    'assets/images/fit_mind_pic.jpg',
                  ),
                  const SizedBox(height: 32),
                  _buildFeaturedProject(
                    'Life Link',
                    'Community blood donation platform with real-time routing.',
                    ['Flutter', 'Google Maps', 'Node.js'],
                    'assets/images/life_link_image.jpg',
                  ),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildFeaturedProject(
                      'Fit Mind',
                      'Health & activity tracker with real-time biometric charts.',
                      ['Flutter', 'Firebase', 'Provider'],
                      'assets/images/fit_mind_pic.jpg',
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: _buildFeaturedProject(
                      'Life Link',
                      'Community blood donation platform with real-time routing.',
                      ['Flutter', 'Google Maps', 'Node.js'],
                      'assets/images/life_link_image.jpg',
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 48),
            if (isMobile)
              TextButton.icon(
                onPressed: () => context.go('/projects'),
                icon: const Text('View All Projects'),
                label: const Icon(Icons.arrow_forward, size: 16),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFBEB6FF),
                ),
              ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1);
  }

  Widget _buildFeaturedProject(String title, String desc, List<String> tags, String image) {
    return ProjectCard(
      title: title,
      description: desc,
      tags: tags,
      imagePath: image,
      onGitHub: () {},
      onLiveDemo: () {},
      isFeatured: true,
    );
  }
}

class _AboutPreview extends StatelessWidget {
  const _AboutPreview();

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(MediaQuery.of(context).size.width);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          children: [
            Text(
              'BRIEF STORY',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: const Color(0xFFBEB6FF),
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'I am a Flutter-focused developer dedicated to building high-performance mobile and web applications. '
              'I care deeply about clean architecture, user experience, and turning complex ideas into polished products. '
              'Currently expanding my expertise into full-stack development to build end-to-end scalable solutions.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isMobile ? 18 : 22,
                color: Colors.white.withValues(alpha: 0.8),
                height: 1.6,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 32),
            TextButton.icon(
              onPressed: () => context.go('/experience'),
              icon: const Text('More About Me'),
              label: const Icon(Icons.arrow_forward, size: 16),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6C63FF),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1);
  }
}

class _FinalCTASection extends StatelessWidget {
  const _FinalCTASection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      decoration: BoxDecoration(
        color: const Color(0xFF6C63FF).withValues(alpha: 0.05),
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Ready to build something amazing?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'I\'m currently available for new projects and collaborations.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => context.go('/contact'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text(
              'Let\'s Connect',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 1.seconds);
  }
}

class _BackgroundEffects extends StatelessWidget {
  const _BackgroundEffects();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: const Color(0xFF02020A)),
        CustomPaint(
          size: Size.infinite,
          painter: GridPainter(),
        ),
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
