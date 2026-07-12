import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/project_card.dart';
import '../widgets/footer.dart';
import '../widgets/grid_painter.dart';
import 'portfolio_home_page.dart';
import 'experience_page.dart';
import 'skills_page.dart';
import 'contact_page.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<Offset> _mousePosition = ValueNotifier(Offset.zero);

  @override
  void dispose() {
    _scrollController.dispose();
    _mousePosition.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 800;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFF02020A),
      drawer: isMobile ? const CustomDrawer() : null,
      body: MouseRegion(
        onHover: (event) => _mousePosition.value = event.position,
        child: Stack(
          children: [
            // Premium Background Effects
            const _ProjectsBackground(),

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
                  ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.2),
                  leading: isMobile
                      ? IconButton(
                          icon: const Icon(Icons.menu, color: Color(0xFF6C63FF)),
                          onPressed: () => scaffoldKey.currentState?.openDrawer(),
                        )
                      : null,
                  title: Padding(
                    padding: EdgeInsets.only(left: isMobile ? 0 : 40),
                    child: const Text(
                      'Ubaid Ullah',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                        letterSpacing: 2,
                        color: Colors.white,
                      ),
                    ),
                  ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.2),
                  actions: [
                    if (!isMobile) ...[
                      _navItem('Home', const PortfolioHomePage()),
                      _navItem('Projects', const ProjectsPage(), isSelected: true),
                      _navItem('Experience', const ExperiencePage()),
                      _navItem('Skills', const SkillsPage()),
                      _navItem('Contact', const ContactPage()),
                      const SizedBox(width: 40),
                    ],
                  ],
                ),

                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60),
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
                            ).animate().fadeIn(duration: 800.ms, curve: Curves.easeOutCubic).slideY(begin: 0.2),
                            
                            const SizedBox(height: 20),
                            
                            // Glowing Divider
                            Container(
                              height: 4,
                              width: 100,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF6C63FF), Color(0xFF00FF94)],
                                ),
                                borderRadius: BorderRadius.circular(2),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF6C63FF).withValues(alpha: 0.5),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                            ).animate().scaleX(begin: 0, alignment: Alignment.centerLeft, duration: 1.seconds, curve: Curves.easeOutBack),
                            
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
                            ).animate().fadeIn(delay: 200.ms, duration: 800.ms).slideY(begin: 0.1),
                            
                            const SizedBox(height: 80),

                            // Project Grid with Staggered Reveal
                            isMobile
                                ? Column(children: _buildProjects(isMobile))
                                : GridView.count(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 32,
                                    mainAxisSpacing: 32,
                                    childAspectRatio: 0.8,
                                    children: _buildProjects(isMobile),
                                  ),

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

  List<Widget> _buildProjects(bool isMobile) {
    final projects = [
      ProjectCard(
        title: 'Fit Mind',
        description: 'A comprehensive health and activity tracker. Features real-time syncing, custom biometric charts, and a highly interactive dashboard with micro-interactions.',
        imagePath: 'assets/images/3D Developer Avatar.png',
        tags: const ['Flutter', 'Firebase', 'Provider', 'HealthKit API'],
        isFeatured: true,
        onLiveDemo: () {},
        onGitHub: () {},
      ),
      ProjectCard(
        title: 'Blood Link',
        description: 'A community-driven blood donation platform connecting donors with recipients in real-time. Includes location-based routing and secure messaging.',
        imagePath: 'assets/images/3D Developer Avatar.png',
        tags: const ['Flutter', 'Google Maps API', 'Node.js'],
        isPrivate: true,
        onLiveDemo: () {},
        onGitHub: () {},
      ),
      // Add more projects as needed
    ];

    return projects.asMap().entries.map((entry) {
      final index = entry.key;
      final project = entry.value;

      return project
          .animate()
          .fadeIn(delay: (400 + (index * 200)).ms, duration: 800.ms)
          .slideY(begin: 0.1, curve: Curves.easeOutBack)
          .scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack);
    }).toList();
  }

  Widget _navItem(String title, Widget destination, {bool isSelected = false}) {
    return _AnimatedNavItem(title: title, isSelected: isSelected, destination: destination);
  }
}

class _AnimatedNavItem extends StatefulWidget {
  final String title;
  final bool isSelected;
  final Widget destination;

  const _AnimatedNavItem({required this.title, this.isSelected = false, required this.destination});

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
        onPressed: widget.isSelected
            ? null
            : () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => widget.destination)),
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
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 2,
                width: widget.isSelected || _isHovered ? 20 : 0,
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    if (widget.isSelected || _isHovered)
                      BoxShadow(color: const Color(0xFF6C63FF).withValues(alpha: 0.5), blurRadius: 4),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.2);
  }
}

class _ProjectsBackground extends StatelessWidget {
  const _ProjectsBackground();

  @override
  Widget build(BuildContext context) {
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
        const _BackgroundCodeSnippets(),

        // Blurred Aurora Blobs
        Positioned(
          top: 200,
          left: -150,
          child: _AuroraBlob(color: const Color(0xFF6C63FF).withValues(alpha: 0.07), size: 600),
        ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(begin: 0, end: 100, duration: 10.seconds),
        
        Positioned(
          bottom: 100,
          right: -200,
          child: _AuroraBlob(color: const Color(0xFF00FF94).withValues(alpha: 0.05), size: 700),
        ).animate(onPlay: (c) => c.repeat(reverse: true)).moveX(begin: 0, end: -100, duration: 15.seconds),

        // Floating particles
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
        ).animate(onPlay: (c) => c.repeat(reverse: true))
         .moveY(begin: 0, end: 50, duration: (10 + random.nextInt(10)).seconds);
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
    ).animate(onPlay: (c) => c.repeat(reverse: true))
     .moveY(begin: 0, end: -100, duration: (5 + random.nextInt(10)).seconds)
     .fadeIn(duration: 2.seconds)
     .fadeOut(delay: 3.seconds, duration: 2.seconds);
  }
}
