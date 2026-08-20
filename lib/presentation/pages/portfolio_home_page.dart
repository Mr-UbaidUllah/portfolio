import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/app_breakpoints.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/portfolio_card.dart';
import '../widgets/footer.dart';
import '../widgets/grid_painter.dart';

import '../widgets/portfolio_navbar.dart';


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

  Widget _buildSectionDivider() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Divider(
            color: Colors.white.withValues(alpha: 0.05),
            thickness: 1,
          ),
        ),
      ),
    );
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
                            const Color(0xFF38BDF8).withValues(alpha: 0.06),
                            const Color(0xFF38BDF8).withValues(alpha: 0),
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

                      // 1. Hero Section
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1200),
                          child: const PortfolioCard(),
                        ),
                      ).animate().fadeIn(duration: 1.2.seconds).scale(
                          begin: const Offset(0.95, 0.95),
                          curve: Curves.easeOutCubic),

                      _buildSectionDivider(),

                      // 2. About Me Preview
                      const _AboutPreview(),

                      _buildSectionDivider(),

                      // 3. Experience Section
                      const _ExperienceSection(),

                      _buildSectionDivider(),

                      // 4. Selected Work Section
                      const _SelectedWorkSection(),

                      _buildSectionDivider(),

                      // 5. Toolbox Section
                      const _ToolboxSection(),

                      _buildSectionDivider(),

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
                            colors: [Color(0xFF38BDF8), Color(0xFF34D399)],
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



class _TechIcon extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _TechIcon(
      {required this.icon, required this.label, required this.color});

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
            color: _isHovered
                ? widget.color.withValues(alpha: 0.1)
                : Colors.white.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered
                  ? widget.color.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.05),
              width: 1.5,
            ),
          ),
          child: Icon(widget.icon,
              color: _isHovered ? widget.color : const Color(0xFF6E82A6),
              size: 28),
        ),
      ),
    );
  }
}

class _AboutPreview extends StatelessWidget {
  const _AboutPreview();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = AppBreakpoints.isMobile(size.width);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1);
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ABOUT',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF38BDF8),
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 24),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF9FB0CC),
                      height: 1.6,
                      fontWeight: FontWeight.w300),
                  children: [
                    TextSpan(
                        text: 'I build cross-platform mobile apps end to end',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            ' — from architecture through deployment. Over the past 3+ years I\'ve shipped 10+ Flutter applications spanning healthcare, e-commerce, fitness and logistics, most of them as independent, self-directed projects where I owned the full build.\n\n'),
                    TextSpan(text: 'I specialize in '),
                    TextSpan(
                        text: 'Flutter and Dart',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    TextSpan(text: ', with backends in '),
                    TextSpan(
                        text: 'Node.js and Firebase',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            '. I integrate REST APIs, implement authentication and real-time data, and structure apps using Clean Architecture, MVC, and the Repository pattern so they stay maintainable as they grow.'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
        const SizedBox(width: 60),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFocusItem(
                  'FRONTEND', 'Flutter, Dart, Provider / Riverpod / Bloc',
                  isFirst: true),
              _buildFocusItem('BACKEND',
                  'Node.js, Firebase, MongoDB, PostgreSQL, REST APIs'),
              _buildFocusItem('ARCHITECTURE',
                  'Clean Architecture, MVC, Repository Pattern'),
              _buildFocusItem(
                  'LOOKING FOR', 'Flutter, Mobile App, or Full-Stack roles'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ABOUT',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: Color(0xFF38BDF8),
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'I build cross-platform mobile apps end to end — from architecture through deployment. Over the past 3+ years I\'ve shipped 10+ Flutter applications spanning healthcare, e-commerce, fitness and logistics.',
          style: TextStyle(fontSize: 16, color: Color(0xFF9FB0CC), height: 1.6),
        ),
        const SizedBox(height: 40),
        _buildFocusItem('FRONTEND', 'Flutter, Dart, Provider / Riverpod / Bloc',
            isFirst: true),
        _buildFocusItem(
            'BACKEND', 'Node.js, Firebase, MongoDB, PostgreSQL, REST APIs'),
        _buildFocusItem(
            'ARCHITECTURE', 'Clean Architecture, MVC, Repository Pattern'),
      ],
    );
  }

  Widget _buildFocusItem(String key, String value, {bool isFirst = false}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: isFirst ? 0 : 16, bottom: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF1E2A42))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            key,
            style: const TextStyle(
              color: Color(0xFF34D399),
              fontSize: 12,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF9FB0CC),
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExperienceSection extends StatelessWidget {
  const _ExperienceSection();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = AppBreakpoints.isMobile(size.width);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'EXPERIENCE',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: Color(0xFF38BDF8),
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Where I\'ve built',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 48),
            _buildTimeline(isMobile),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1);
  }

  Widget _buildTimeline(bool isMobile) {
    return Column(
      children: [
        _TimelineItem(
          role: 'Independent Flutter & Full-Stack Developer',
          company: 'Freelance / Self-Directed Projects',
          period: '2022 – Present',
          location: 'Remote',
          points: const [
            'Designed and shipped 10+ Flutter applications end-to-end, from architecture through deployment, spanning healthcare, e-commerce, fitness, and logistics use cases',
            'Built and integrated Node.js and Firebase backends — REST APIs, authentication, real-time databases — to support production mobile apps',
            'Applied Clean Architecture, MVC, and Repository patterns consistently to keep codebases maintainable and testable',
          ],
          isFirst: true,
        ),
        _TimelineItem(
          role: 'Flutter Developer',
          company: 'Precise',
          period: 'Sept 2024 – Dec 2024',
          location: 'Peshawar, Pakistan',
          points: const [
            'Developed scalable Flutter applications following clean architecture principles, improving maintainability across two production apps',
            'Integrated REST APIs and optimized application performance, reducing UI jank and load times',
            'Converted Figma designs into responsive, pixel-accurate Flutter interfaces for cross-platform delivery',
            'Collaborated with backend developers on testing and bug fixing within an Agile workflow',
          ],
          isLast: false,
          isMuted: true,
        ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String role;
  final String company;
  final String period;
  final String location;
  final List<String> points;
  final bool isFirst;
  final bool isLast;
  final bool isMuted;

  const _TimelineItem({
    required this.role,
    required this.company,
    required this.period,
    required this.location,
    required this.points,
    this.isFirst = false,
    this.isLast = false,
    this.isMuted = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line and dot
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SizedBox(
              width: 20,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  if (!isLast)
                    Container(
                      width: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            isMuted
                                ? const Color(0xFF2A3B5C)
                                : const Color(0xFF38BDF8),
                            const Color(0xFF1E2A42),
                          ],
                        ),
                      ),
                    ),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A0F1C),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isMuted
                            ? const Color(0xFF2A3B5C)
                            : const Color(0xFF38BDF8),
                        width: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 24),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 48.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6E82A6),
                          fontFamily: 'monospace'),
                      children: [
                        TextSpan(
                            text: company,
                            style: const TextStyle(color: Color(0xFF38BDF8))),
                        TextSpan(text: ' · $location · $period'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...points.map((point) => Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('▸ ',
                                style: TextStyle(
                                    color: Color(0xFF34D399), fontSize: 14)),
                            Expanded(
                              child: Text(
                                point,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF9FB0CC),
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedWorkSection extends StatelessWidget {
  const _SelectedWorkSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SELECTED WORK',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: Color(0xFF38BDF8),
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Projects',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Six apps across four domains — each one built end to end, front end through backend.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF9FB0CC),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 48),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final crossAxisCount = width > 900 ? 2 : 1;
                final itemWidth =
                    crossAxisCount == 2 ? (width - 24) / 2 : width;

                return Wrap(
                  spacing: 24,
                  runSpacing: 24,
                  children: [
                    _buildProjectCard(
                      title: 'LifeLink',
                      subheading: 'BLOOD DONATION PLATFORM',
                      description:
                          'Real-time request-matching system connecting blood donors to urgent requests, with authenticated flows and instant push notifications when a match is needed.',
                      technologies: [
                        'Flutter',
                        'Firebase Auth',
                        'Realtime DB',
                        'Push Notifications'
                      ],
                      accentColor: const Color(0xFFF87171),
                      width: itemWidth,
                    ),
                    _buildProjectCard(
                      title: 'Marble Factory Management',
                      subheading: 'ADMIN & ORDER-PROCESSING SYSTEM',
                      description:
                          'Live inventory and order-status tracking for daily factory operations. PostgreSQL over Firebase here — a deliberate call for relational order/inventory data.',
                      technologies: ['Flutter', 'Node.js', 'PostgreSQL'],
                      accentColor: const Color(0xFF60A5FA),
                      width: itemWidth,
                    ),
                    _buildProjectCard(
                      title: 'Synapse',
                      subheading: 'MENTORING PLATFORM',
                      description:
                          'High-performance session-scheduling app built with clean architecture and efficient state management for smooth, responsive booking flows.',
                      technologies: ['Flutter', 'Firebase', 'Cloud Functions'],
                      accentColor: const Color(0xFF34D399),
                      width: itemWidth,
                    ),
                    _buildProjectCard(
                      title: 'Dermatology Healthcare App',
                      subheading: 'APPOINTMENT BOOKING',
                      description:
                          'Responsive booking platform with doctor listings and dynamic filtering, built to cut booking friction for patients.',
                      technologies: ['Flutter', 'Firebase', 'Node.js'],
                      accentColor: const Color(0xFFA78BFA),
                      width: itemWidth,
                    ),
                    _buildProjectCard(
                        title: 'E-Commerce Application',
                        subheading: 'Shopping & Product Management',
                        description:
                            'Full purchase flow with secure authentication, product management, and shopping cart functionality end to end.',
                        technologies: [
                          'Flutter',
                          'Node.js',
                          'MongoDB',
                        ],
                        accentColor: const Color(0xFFA78BFA),
                        width: itemWidth),
                    _buildProjectCard(
                        title: 'Fitness Application',
                        subheading: 'Workout & Nutrition',
                        description:
                            'Workout-tracking app with comprehensive profile management and progress history over time.',
                        technologies: [
                          'Flutter',
                          'Firebase',
                        ],
                        accentColor: const Color(0xFFA78BFA),
                        width: itemWidth)
                  ],
                );
              },
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1);
  }

  Widget _buildProjectCard({
    required String title,
    required String subheading,
    required String description,
    required List<String> technologies,
    required Color accentColor,
    required double width,
    bool isHovered = false,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1524),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              boxShadow: [
                if(isHovered)
                  BoxShadow(
                    color: isHovered ? Colors.blue.withValues(alpha: 0.5) : Colors.transparent,
                  )
              ],
              color: accentColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subheading,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF6E82A6),
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            description,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF9FB0CC),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: technologies.map((tech) => _buildToolChip(tech)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildToolChip(String tech) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Text(
        tech,
        style: const TextStyle(
          color: Color(0xFF6E82A6),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _ToolboxSection extends StatelessWidget {
  const _ToolboxSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TOOLBOX',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: Color(0xFF38BDF8),
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Skills',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 48),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final crossAxisCount = width > 900 ? 3 : (width > 600 ? 2 : 1);
                final itemWidth =
                    (width - (crossAxisCount - 1) * 40) / crossAxisCount;

                return Wrap(
                  spacing: 40,
                  runSpacing: 48,
                  children: [
                    _buildCategory('LANGUAGES', ['Dart', 'JavaScript', 'SQL'],
                        width: itemWidth),
                    _buildCategory('FRAMEWORKS', ['Flutter', 'Node.js'],
                        width: itemWidth),
                    _buildCategory('BACKEND & DATA',
                        ['Firebase', 'MongoDB', 'PostgreSQL', 'REST APIs'],
                        width: itemWidth),
                    _buildCategory(
                        'STATE MANAGEMENT', ['Provider', 'Riverpod', 'Bloc'],
                        width: itemWidth),
                    _buildCategory('ARCHITECTURE',
                        ['Clean Architecture', 'MVC', 'Repository Pattern'],
                        width: itemWidth),
                    _buildCategory('CLOUD & DEVOPS',
                        ['Firebase Hosting', 'GitHub Actions', 'Docker'],
                        width: itemWidth),
                    _buildCategory('TOOLS',
                        ['Git', 'Postman', 'Android Studio', 'Figma', 'Xcode'],
                        width: itemWidth),
                    _buildCategory('CORE COMPETENCIES',
                        ['Agile', 'Cross-functional Comms', 'Problem Solving'],
                        width: itemWidth),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1);
  }

  Widget _buildCategory(String title, List<String> skills,
      {required double width}) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6E82A6),
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.white.withValues(alpha: 0.05),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: skills.map((skill) {
              return _buildSkillChip(skill, false);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String skill, bool highlighted) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: highlighted ? const Color(0xFF38BDF8) : const Color(0xFF0D1524),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: highlighted
              ? const Color(0xFF38BDF8)
              : Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Text(
        skill,
        style: TextStyle(
          color:
              highlighted ? const Color(0xFF02020A) : const Color(0xFF9FB0CC),
          fontSize: 13,
          fontWeight: highlighted ? FontWeight.bold : FontWeight.w500,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

class _FinalCTASection extends StatelessWidget {
  const _FinalCTASection();

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1524),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFF1E2A42)),
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.5,
          colors: [
            const Color(0xFF38BDF8).withValues(alpha: 0.1),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Let\'s build something.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text(
              'Open to Flutter Developer, Mobile App Developer, and Flutter + Node.js full-stack roles — remote-friendly.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: const Color(0xFF9FB0CC),
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              _CTAButton(
                label: 'ubaidullah.dev09@gmail.com',
                icon: Icons.mail_outline,
                isPrimary: true,
                onTap: () => _launchUrl('mailto:ubaidullah.dev09@gmail.com'),
              ),
              _CTAButton(
                label: 'LinkedIn',
                isPrimary: false,
                onTap: () => _launchUrl(
                    'https://www.linkedin.com/in/ubaid-ullah-84b442285/'),
              ),
              _CTAButton(
                label: 'GitHub',
                isPrimary: false,
                onTap: () => _launchUrl('https://github.com/Mr-UbaidUllah'),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 1.seconds);
  }
}

class _CTAButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isPrimary;
  final VoidCallback onTap;

  const _CTAButton({
    required this.label,
    this.icon,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFF38BDF8) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isPrimary ? null : Border.all(color: const Color(0xFF1E2A42)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: isPrimary ? Colors.black : Colors.white,
              ),
              const SizedBox(width: 10),
            ],
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? Colors.black : Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                fontFamily: 'monospace',
              ),
            ),
          ],
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
        Container(color: const Color(0xFF0A0F1C)),
        CustomPaint(
          size: Size.infinite,
          painter: GridPainter(),
        ),
        Positioned(
          top: -100,
          right: -100,
          child: _BlurredOrb(
              color: const Color(0xFF38BDF8).withValues(alpha: 0.1), size: 600),
        ).animate(onPlay: (c) => c.repeat(reverse: true)).move(
            begin: Offset.zero,
            end: const Offset(-80, 80),
            duration: 12.seconds,
            curve: Curves.easeInOut),
        Positioned(
          bottom: -150,
          left: -100,
          child: _BlurredOrb(
              color: const Color(0xFF34D399).withValues(alpha: 0.05),
              size: 700),
        ).animate(onPlay: (c) => c.repeat(reverse: true)).move(
            begin: Offset.zero,
            end: const Offset(80, -80),
            duration: 18.seconds,
            curve: Curves.easeInOut),
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
          color: Colors.white.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
      )
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .moveY(
              end: -30 - random.nextDouble() * 40,
              duration: (7 + random.nextInt(7)).seconds)
          .fadeIn(duration: 2.seconds)
          .fadeOut(delay: 4.seconds, duration: 2.seconds),
    );
  }
}
