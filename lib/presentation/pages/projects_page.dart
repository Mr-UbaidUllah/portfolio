import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/app_breakpoints.dart';
import '../widgets/portfolio_navbar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/project_card.dart';
import '../widgets/footer.dart';
import '../widgets/grid_painter.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage>
    with AutomaticKeepAliveClientMixin {
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

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
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
            // Premium Background Effects
            const RepaintBoundary(child: _ProjectsBackground()),

            // Mouse Follow Glow (Spotlight)
            if (!isMobile)
              ValueListenableBuilder<Offset>(
                valueListenable: _mousePosition,
                builder: (context, position, child) {
                  return Positioned(
                    left: position.dx - 400,
                    top: position.dy - 400,
                    child: IgnorePointer(
                      child: Container(
                        width: 800,
                        height: 800,
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
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 60),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Staggered Entrance for Title
                            const Text(
                              'Selected\nWorks',
                              style: TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.w900,
                                height: 1.0,
                                color: Colors.white,
                                letterSpacing: -2,
                              ),
                            )
                                .animate()
                                .fadeIn(
                                    duration: 800.ms,
                                    curve: Curves.easeOutCubic)
                                .slideY(begin: 0.2),

                            const SizedBox(height: 20),

                            // Glowing Divider
                            Container(
                              height: 4,
                              width: 100,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF6C63FF),
                                    Color(0xFF00FF94)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(2),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF6C63FF)
                                        .withValues(alpha: 0.5),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                            ).animate().scaleX(
                                begin: 0,
                                alignment: Alignment.centerLeft,
                                duration: 1.seconds,
                                curve: Curves.easeOutBack),

                            const SizedBox(height: 32),

                            // Subtitle
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 600),
                              child: Text(
                                'A collection of high-performance cross-platform applications, focusing on fluid animations, robust state management, and premium user experiences.',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white.withValues(alpha: 0.6),
                                  height: 1.6,
                                ),
                              ),
                            )
                                .animate()
                                .fadeIn(delay: 200.ms, duration: 800.ms)
                                .slideY(begin: 0.1),

                            const SizedBox(height: 80),

                            // Project Grid with Staggered Reveal
                            _buildProjectsGrid(isMobile, size.width),

                            const SizedBox(height: 120),
                            const Footer().animate().fadeIn(delay: 400.ms),
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

  Widget _buildProjectsGrid(bool isMobile, double screenWidth) {
    final projects = _getProjectData();

    if (isMobile) {
      return Column(
        children: projects
            .asMap()
            .entries
            .map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: _animateProject(entry.value, entry.key),
                ))
            .toList(),
      );
    }

    int crossAxisCount = 2;
    if (screenWidth > AppBreakpoints.largeDesktop) {
      crossAxisCount = 3;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 32,
        mainAxisSpacing: 32,
        mainAxisExtent:
            680, // Fixed: Use mainAxisExtent to prevent RenderFlex overflow on small desktops
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) => _animateProject(projects[index], index),
    );
  }

  Widget _animateProject(Widget project, int index) {
    final bool reduceMotion = MediaQuery.of(context).accessibleNavigation ||
        MediaQuery.of(context).disableAnimations;
    if (reduceMotion) return project;

    return project
        .animate()
        .fadeIn(delay: (200 + (index * 100)).ms, duration: 800.ms)
        .slideY(begin: 0.1, curve: Curves.easeOutBack)
        .scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack);
  }

  List<Widget> _getProjectData() {
    return [
      ProjectCard(
        title: 'Fit Mind',
        description:
            'A comprehensive health and activity tracker. Features real-time syncing, custom biometric charts, and a highly interactive dashboard with micro-interactions.',
        imagePath: 'assets/images/fit_mind_pic.jpg',
        tags: const ['Flutter', 'Firebase', 'Provider', 'HealthKit API'],
        isFeatured: true,
        onLiveDemo: () {},
        onGitHub: () => _launchUrl('https://github.com/Mr-UbaidUllah/fit_mind'),
      ),
      ProjectCard(
        title: 'Life Link',
        description:
            'A community-driven blood donation platform connecting donors with recipients in real-time. Includes location-based routing and secure messaging.',
        imagePath: 'assets/images/life_link_image.jpg',
        tags: const ['Flutter', 'Google Maps API', 'Node.js'],
        isPrivate: true,
        onLiveDemo: () {},
        onGitHub: () => _launchUrl('https://github.com/Mr-UbaidUllah/life_link'),
      ),
      ProjectCard(
          title: "Factory Management System ",
          description: ""
              "A comprehensive health and activity tracker. Features real-time syncing, custom biometric charts, and a highly interactive dashboard with micro-interactions.",
          imagePath: 'assets/images/factory.jpg',
          tags: const ['Flutter', 'Rest Api', 'Node.js'],
          onLiveDemo: () {},
          onGitHub: () => _launchUrl('https://github.com/Mr-UbaidUllah/Marbal-Factory-Managemnet')),
      ProjectCard(
        title: 'Dermatology Healthcare App',
        description:
            'Responsive appointment booking platform with doctor listings and dynamic filtering.',
        imagePath: 'assets/images/derma_pic.jpg',
        tags: ['Flutter', 'Firebase', 'Provider', 'HealthKit API'],
        onLiveDemo: () {},
        onGitHub: () {},
      ),
      ProjectCard(
        title: 'Stallion Wear',
        description:
            'A modern fashion app with sleek and elegant fashion e-commerce app designed with smooth UI, modern animations, and a powerful user experience ',
        imagePath: 'assets/images/fashion.jpg',
        tags: ['Flutter, Firebase', 'Rest Api', 'Node.js' 'Provider'],
        onLiveDemo: () {},
        onGitHub: () => _launchUrl('https://github.com/Mr-UbaidUllah/stalllion_wear'),
      ),
      ProjectCard(
          title: 'Synapse',
          description: 'High-performance, responsive app utilizing clean architecture for seamless state management.',
          imagePath: 'assets/images/synape.jpg',
          tags: [
            'Flutter',
            'Firebase',
            'Provider',
          ],
          onLiveDemo: () {},
          onGitHub: () => _launchUrl('https://github.com/Mr-UbaidUllah/synapse'))
    ];
  }
}

class _ProjectsBackground extends StatelessWidget {
  const _ProjectsBackground();

  @override
  Widget build(BuildContext context) {
    final bool reduceMotion = MediaQuery.of(context).accessibleNavigation ||
        MediaQuery.of(context).disableAnimations;
    return Stack(
      children: [
        // Base dark background
        Container(color: const Color(0xFF02020A)),

        // Grid Pattern
        Opacity(
          opacity: 0.4,
          child: CustomPaint(
            size: Size.infinite,
            painter: GridPainter(),
          ),
        ),

        // Animated Code Snippets (Background)
        if (!reduceMotion) const _BackgroundCodeSnippets(),

        // Blurred Aurora Blobs
        Positioned(
          top: 200,
          left: -150,
          child: _AuroraBlob(
              color: const Color(0xFF6C63FF).withValues(alpha: 0.07),
              size: 600),
        )
            .animate(
                onPlay: (c) =>
                    reduceMotion ? c.stop() : c.repeat(reverse: true))
            .moveY(begin: 0, end: 100, duration: 10.seconds),

        Positioned(
          bottom: 100,
          right: -200,
          child: _AuroraBlob(
              color: const Color(0xFF00FF94).withValues(alpha: 0.05),
              size: 700),
        )
            .animate(
                onPlay: (c) =>
                    reduceMotion ? c.stop() : c.repeat(reverse: true))
            .moveX(begin: 0, end: -100, duration: 15.seconds),

        // Floating particles
        if (!reduceMotion)
          ...List.generate(15, (index) => _FloatingParticle(index: index)),
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

class _BackgroundCodeSnippets extends StatelessWidget {
  const _BackgroundCodeSnippets();

  @override
  Widget build(BuildContext context) {
    final snippets = [
      'class Project extends StatelessWidget {',
      'final String title;',
      'void main() => runApp(Portfolio());',
      'canvas.drawPath(path, painter);',
      'const Duration(milliseconds: 800)',
      'Curves.easeOutCubic',
      'await repository.getData();',
      'StreamBuilder<User>(...)',
    ];

    return Stack(
      children: snippets.asMap().entries.map((entry) {
        final random = math.Random(entry.key);
        return Positioned(
          top: random.nextDouble() * 1000,
          left: random.nextDouble() * 1200,
          child: Opacity(
            opacity: 0.03,
            child: Text(
              entry.value,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'monospace',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(
            begin: 0, end: 50, duration: (10 + random.nextInt(10)).seconds);
      }).toList(),
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
    return Positioned(
      top: random.nextDouble() * 1000,
      left: random.nextDouble() * 1500,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .moveY(begin: 0, end: -100, duration: (5 + random.nextInt(10)).seconds)
        .fadeIn(duration: 2.seconds)
        .fadeOut(delay: 3.seconds, duration: 2.seconds);
  }
}
