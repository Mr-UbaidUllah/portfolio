import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/app_breakpoints.dart';
import '../widgets/portfolio_navbar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/experience_item.dart';
import '../widgets/footer.dart';
import '../widgets/grid_painter.dart';
import '../widgets/resume_preview_modal.dart';
import 'package:go_router/go_router.dart';

class ExperiencePage extends StatefulWidget {
  const ExperiencePage({super.key});

  @override
  State<ExperiencePage> createState() => _ExperiencePageState();
}

class _ExperiencePageState extends State<ExperiencePage> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<Offset> _mousePosition = ValueNotifier(Offset.zero);

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scrollController.dispose();
    _mousePosition.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final size = MediaQuery.of(context).size;
    final isMobile = AppBreakpoints.isMobile(size.width);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFF02020A),
      drawer: isMobile ? const CustomDrawer() : null,
      body: MouseRegion(
        onHover: (event) => _mousePosition.value = event.position,
        child: Stack(
          children: [
            // --- Premium Visual Elements ---
            const _ExperienceBackground(),

            // Interactive Spotlight follow (Desktop Only)
            if (!isMobile)
              ValueListenableBuilder<Offset>(
                valueListenable: _mousePosition,
                builder: (context, position, child) {
                  return Positioned(
                    left: position.dx - 600,
                    top: position.dy - 600,
                    child: IgnorePointer(
                      child: Container(
                        width: 1200,
                        height: 1200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF6C63FF).withValues(alpha: 0.04),
                              const Color(0xFF6C63FF).withValues(alpha: 0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

            CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                PortfolioNavbar(isMobile: isMobile, scaffoldKey: scaffoldKey),

                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1100),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 24 : 40,
                          vertical: 100,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // --- Hero Header Section ---
                            _buildHeroHeader(isMobile),

                            const SizedBox(height: 100),

                            // --- Achievement Quick Highlights ---
                            _buildQuickStats(isMobile),

                            const SizedBox(height: 120),

                            // --- Vertical Experience Timeline ---
                            _buildExperienceTimeline(),

                            const SizedBox(height: 150),

                            // --- Call To Action Section ---
                            _buildCTA(context, isMobile),

                            const SizedBox(height: 120),
                            const Footer().animate().fadeIn(delay: 1.2.seconds),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroHeader(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Large Animated Title
        Text(
          'Experience',
          style: TextStyle(
            fontSize: isMobile ? 64 : 110,
            fontWeight: FontWeight.w900,
            height: 0.8,
            color: Colors.white,
            letterSpacing: -6,
          ),
        ).animate().fadeIn(duration: 800.ms, curve: Curves.easeOut).slideY(begin: 0.2),

        const SizedBox(height: 32),

        // Animated Glowing Divider
        Container(
          height: 8,
          width: 160,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF00FF94)],
            ),
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6C63FF).withValues(alpha: 0.8),
                blurRadius: 25,
                spreadRadius: 2,
              ),
            ],
          ),
        ).animate().scaleX(begin: 0, alignment: Alignment.centerLeft, duration: 1.5.seconds, curve: Curves.elasticOut),

        const SizedBox(height: 48),

        // Hero Subtitle
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 750),
          child: Text(
            'Building scalable applications, solving real-world problems, and continuously growing as a software engineer.',
            style: TextStyle(
              fontSize: isMobile ? 20 : 24,
              color: Colors.white.withValues(alpha: 0.6),
              height: 1.6,
              fontWeight: FontWeight.w300,
              letterSpacing: 0.5,
            ),
          ),
        ).animate().fadeIn(delay: 300.ms, duration: 1.seconds).slideY(begin: 0.1),
      ],
    );
  }

  Widget _buildQuickStats(bool isMobile) {
    final stats = [
      {'value': '10+', 'label': 'Mobile Apps'},
      {'value': '2+', 'label': 'Years Flutter'},
      {'value': '5+', 'label': 'SaaS Projects'},
      {'value': '100%', 'label': 'Clean Code'},
    ];

    return Wrap(
      spacing: isMobile ? 30 : 60,
      runSpacing: 40,
      children: stats.map((stat) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stat['value']!,
              style: const TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -2,
              ),
            ).animate().shimmer(duration: 3.seconds, color: const Color(0xFF00FF94)).fadeIn(duration: 1.seconds).slideY(begin: 0.3),
            Text(
              stat['label']!.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.4),
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildExperienceTimeline() {
    final bool reduceMotion = MediaQuery.of(context).accessibleNavigation || 
                             MediaQuery.of(context).disableAnimations;

    final experiences = [
      const ExperienceItem(
        title: 'Frontend Flutter Developer',
        company: 'Precise',
        period: 'Jan 2024 - Present',
        location: 'Remote',
        employmentType: 'Full-time',
        isFirst: true,
        isCurrent: true,
        technologies: ['Flutter', 'Riverpod', 'Firebase', 'Material 3', 'Dart', 'CI/CD', 'GitHub Actions', 'Figma'],
        responsibilities: [
          'Architected a highly scalable, multi-tenant Flutter application serving 1M+ active users.',
          'Implemented complex state management using Riverpod and customized a design system mapping directly to Material 3 tokens.',
          'Optimized app performance, achieving 60 FPS on low-end devices via Isolate-based computing.',
          'Integrated real-time data sync using Firestore and optimized offline capabilities.',
          'Collaborated with cross-functional teams to define, design, and ship new features.'
        ],
        achievements: [
          'Improved application performance by 40% through isolate-based computation.',
          'Reduced codebase size by 30% by implementing a custom reusable design system.',
          'Successfully launched 3 major feature sets ahead of schedule.'
        ],
      ),
      const ExperienceItem(
        title: 'Mobile Application Developer',
        company: 'Freelance / Agency',
        period: 'June 2023 - Dec 2023',
        location: 'Global / Hybrid',
        employmentType: 'Contract',
        technologies: ['Flutter', 'BLE', 'IoT', 'REST API', 'Provider', 'Figma', 'Node.js', 'PostgreSQL'],
        responsibilities: [
          'Transitioned primary tech stack from React Native to Flutter for better performance and animation fluidity.',
          'Developed custom IoT companion apps with complex BLE communication protocols.',
          'Collaborated with international designers to implement pixel-perfect Figma designs.',
          'Maintained a 99.9% crash-free rate across multiple production apps.'
        ],
        achievements: [
          'Successfully delivered 5+ production-grade mobile applications.',
          'Developed a reusable IoT communication layer used across 3 distinct projects.'
        ],
      ),
      const ExperienceItem(
        title: 'Computer Science Scholar',
        company: 'University of Peshawar',
        period: '2022 - 2026',
        location: 'Peshawar, PK',
        employmentType: 'Education',
        isLast: true,
        technologies: ['C++', 'Data Structures', 'Algorithms', 'Mobile Computing', 'UI/UX Design', 'Discrete Math'],
        responsibilities: [
          'Focused on algorithmic efficiency and high-performance computing.',
          'Lead developer for the University Mobile Portal project.',
          'Active member of the Competitive Programming Society.',
          'Research Lead for \"AI-driven Mobile Optimization\" project.'
        ],
        achievements: [
          'Top 5% of class in Data Structures and Algorithm analysis.',
          'Winner of \"Best Mobile App Architecture\" at 2023 University Hackathon.',
          'Achieved 30% reduction in battery consumption in mobile research project.'
        ],
      ),
    ];

    return Column(
      children: experiences.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        if (reduceMotion) return item;
        return item.animate().fadeIn(delay: (600 + (index * 200)).ms).slideX(begin: -0.05);
      }).toList(),
    );
  }

  Widget _buildCTA(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: isMobile ? 60 : 100, horizontal: 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF6C63FF).withValues(alpha: 0.15),
            const Color(0xFF00FF94).withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Interested in working together?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -2,
            ),
          ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 4.seconds, color: const Color(0xFFBEB6FF)),
          const SizedBox(height: 24),
          Text(
            'Let\'s build something exceptional and push the boundaries of mobile experiences.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white.withValues(alpha: 0.5),
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 50),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              _AnimatedCTAButton(
                text: 'Resume', 
                icon: Icons.description_outlined, 
                isPrimary: true,
                onPressed: () => ResumePreviewModal.show(context),
              ),
              _AnimatedCTAButton(
                text: 'Contact Me', 
                icon: Icons.arrow_forward_rounded, 
                isPrimary: false,
                onPressed: () => context.go('/contact'),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 1.1.seconds).scale(begin: const Offset(0.95, 0.95));
  }
}

class _AnimatedCTAButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onPressed;

  const _AnimatedCTAButton({
    required this.text, 
    required this.icon, 
    required this.isPrimary,
    required this.onPressed,
  });

  @override
  State<_AnimatedCTAButton> createState() => _AnimatedCTAButtonState();
}

class _AnimatedCTAButtonState extends State<_AnimatedCTAButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focused) => setState(() => _isHovered = focused),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutQuart,
          transform: Matrix4.identity()..translate(0.0, _isHovered ? -8.0 : 0.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                if (_isHovered)
                  BoxShadow(
                    color: (widget.isPrimary ? const Color(0xFF6C63FF) : const Color(0xFF00FF94)).withValues(alpha: 0.4),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
              ],
            ),
            child: ElevatedButton(
              onPressed: widget.onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.isPrimary 
                    ? const Color(0xFF6C63FF) 
                    : Colors.white.withValues(alpha: 0.05),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 26),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: widget.isPrimary 
                      ? BorderSide.none 
                      : BorderSide(color: _isHovered ? const Color(0xFF00FF94) : Colors.white10),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.text,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                  ),
                  const SizedBox(width: 12),
                  Icon(widget.icon, size: 22).animate(target: _isHovered ? 1 : 0).moveX(end: 8).shake(hz: 3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ExperienceBackground extends StatelessWidget {
  const _ExperienceBackground();

  @override
  Widget build(BuildContext context) {
    final bool reduceMotion = MediaQuery.of(context).accessibleNavigation || 
                             MediaQuery.of(context).disableAnimations;
    return RepaintBoundary(
      child: Stack(
        children: [
          Container(color: const Color(0xFF02020A)),
          // Subtle animated grid
          Opacity(
            opacity: 0.2,
            child: CustomPaint(
              size: Size.infinite,
              painter: GridPainter(),
            ),
          ),
          // Large blurred aurora blobs
          Positioned(
            top: -200,
            right: -100,
            child: _AuroraBlob(color: const Color(0xFF6C63FF).withValues(alpha: 0.08), size: 900),
          ).animate(onPlay: (c) => reduceMotion ? c.stop() : c.repeat(reverse: true)).moveY(begin: 0, end: 120, duration: 10.seconds),
          
          Positioned(
            bottom: -150,
            left: -250,
            child: _AuroraBlob(color: const Color(0xFF00FF94).withValues(alpha: 0.05), size: 1000),
          ).animate(onPlay: (c) => reduceMotion ? c.stop() : c.repeat(reverse: true)).moveX(begin: 0, end: 180, duration: 15.seconds),
          
          // Floating decorative particles/stars
          if (!reduceMotion) const _FloatingStars(),
        ],
      ),
    );
  }
}

class _AuroraBlob extends StatelessWidget {
  final Color color;
  final double size;

  const _AuroraBlob({required this.color, required this.size});

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

class _FloatingStars extends StatelessWidget {
  const _FloatingStars();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(25, (index) {
        return Positioned(
          top: (index * 137.5) % 1000,
          left: (index * 243.7) % 1500,
          child: Container(
            width: 2.5,
            height: 2.5,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.white.withValues(alpha: 0.2), blurRadius: 5),
              ],
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(duration: (3 + (index % 4)).seconds).scale(begin: const Offset(0.4, 0.4), end: const Offset(1.8, 1.8)),
        );
      }),
    );
  }
}
