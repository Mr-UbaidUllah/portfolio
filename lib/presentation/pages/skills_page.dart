import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/skill_card.dart';
import '../widgets/footer.dart';
import 'portfolio_home_page.dart';
import 'projects_page.dart';
import 'experience_page.dart';
import 'contact_page.dart';

class SkillsPage extends StatefulWidget {
  const SkillsPage({super.key});

  @override
  State<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> {
  String selectedCategory = 'All';

  final List<Map<String, dynamic>> categories = [
    {'name': 'All', 'icon': Icons.grid_view_rounded},
    {'name': 'Mobile', 'icon': Icons.smartphone_rounded},
    {'name': 'Backend', 'icon': Icons.storage_rounded},
    {'name': 'Design', 'icon': Icons.palette_rounded},
    {'name': 'Tools', 'icon': Icons.construction_rounded},
    {'name': 'Cloud', 'icon': Icons.cloud_done_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFF02020A),
      drawer: isMobile ? const CustomDrawer() : null,
      body: Stack(
        children: [
          // Background Effects
          const _BackgroundMesh(),
          
          CustomScrollView(
            slivers: [
              _buildAppBar(context, isMobile, scaffoldKey),
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 60),
                          _buildHeader(),
                          const SizedBox(height: 60),
                          _buildStats(),
                          const SizedBox(height: 60),
                          _buildFilterTabs(),
                          const SizedBox(height: 40),
                          _buildSkillsGrid(isMobile),
                          const SizedBox(height: 80),
                          _buildCurrentlyLearning(),
                          const SizedBox(height: 100),
                          const Footer().animate().fadeIn(delay: 400.ms),
                          const SizedBox(height: 40),
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
    );
  }

  Widget _buildAppBar(BuildContext context, bool isMobile, GlobalKey<ScaffoldState> scaffoldKey) {
    return SliverAppBar(
      floating: true,
      backgroundColor: const Color(0xFF02020A).withOpacity(0.8),
      elevation: 0,
      leading: isMobile
          ? IconButton(
              icon: const Icon(Icons.menu, color: Color(0xFF6C63FF)),
              onPressed: () => scaffoldKey.currentState?.openDrawer(),
            )
          : null,
      title: Text(
        'Ubaid Ullah',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white.withOpacity(0.9),
        ),
      ),
      actions: [
        if (!isMobile) ...[
          _navItem(context, 'Home', const PortfolioHomePage()),
          _navItem(context, 'Projects', const ProjectsPage()),
          _navItem(context, 'Experience', const ExperiencePage()),
          _navItem(context, 'Skills', const SkillsPage(), isSelected: true),
          _navItem(context, 'Contact', const ContactPage()),
          const SizedBox(width: 20),
        ],
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.white, Color(0xFF6C63FF), Color(0xFF00D2FF)],
          ).createShader(bounds),
          child: const Text(
            'Technical Skills',
            style: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.w900,
              height: 1.1,
              color: Colors.white,
              letterSpacing: -2,
            ),
          ),
        ).animate().fadeIn(duration: 800.ms).slideX(begin: -0.1),
        const SizedBox(height: 20),
        const _AnimatedDivider(),
        const SizedBox(height: 20),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Text(
            'The technologies, tools, and frameworks I use to build modern, scalable, and high-performance applications.',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.6),
              height: 1.6,
            ),
          ),
        ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.05),
      ],
    );
  }

  Widget _buildStats() {
    return Wrap(
      spacing: 40,
      runSpacing: 24,
      children: [
        _statItem('🚀 20+', 'Technologies'),
        _statItem('📱 Flutter', 'Specialist'),
        _statItem('🔥 Full Stack', 'Development'),
        _statItem('🎨 UI/UX', 'Design'),
      ],
    ).animate().fadeIn(delay: 500.ms);
  }

  Widget _statItem(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.4),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          final isSelected = selectedCategory == cat['name'];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () => setState(() => selectedCategory = cat['name']),
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF6C63FF) : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.white24 : Colors.white.withOpacity(0.1),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(cat['icon'], color: isSelected ? Colors.white : Colors.white60, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      cat['name'],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSkillsGrid(bool isMobile) {
    final List<SkillCard> allCards = [
      SkillCard(
        title: 'Mobile Development',
        icon: Icons.smartphone_rounded,
        accentColor: const Color(0xFF6C63FF),
        description: 'Building high-performance, beautiful cross-platform and native mobile applications.',
        skills: [
          SkillProgress(name: 'Flutter', percentage: 0.95),
          SkillProgress(name: 'Dart', percentage: 0.92),
          SkillProgress(name: 'Android', percentage: 0.85),
          SkillProgress(name: 'Riverpod', percentage: 0.90),
          SkillProgress(name: 'BLoC', percentage: 0.88),
        ],
      ),
      SkillCard(
        title: 'Backend Development',
        icon: Icons.storage_rounded,
        accentColor: const Color(0xFF00D2FF),
        description: 'Designing scalable APIs and server-side logic to power robust applications.',
        skills: [
          SkillProgress(name: 'Node.js', percentage: 0.75),
          SkillProgress(name: 'Express.js', percentage: 0.70),
          SkillProgress(name: 'Firebase Auth', percentage: 0.90),
          SkillProgress(name: 'REST APIs', percentage: 0.88),
        ],
      ),
      SkillCard(
        title: 'Database',
        icon: Icons.dataset_rounded,
        accentColor: const Color(0xFFFF3D00),
        description: 'Managing data efficiently with both SQL and NoSQL database solutions.',
        skills: [
          SkillProgress(name: 'Firestore', percentage: 0.92),
          SkillProgress(name: 'PostgreSQL', percentage: 0.65),
          SkillProgress(name: 'MySQL', percentage: 0.70),
        ],
      ),
      SkillCard(
        title: 'UI/UX Design',
        icon: Icons.palette_rounded,
        accentColor: const Color(0xFFFF00D2),
        description: 'Crafting intuitive and visually stunning user interfaces and experiences.',
        skills: [
          SkillProgress(name: 'Figma', percentage: 0.85),
          SkillProgress(name: 'Adobe XD', percentage: 0.75),
          SkillProgress(name: 'Responsive Design', percentage: 0.90),
          SkillProgress(name: 'Wireframing', percentage: 0.88),
        ],
      ),
      SkillCard(
        title: 'Tools & Platforms',
        icon: Icons.construction_rounded,
        accentColor: const Color(0xFF00FF85),
        description: 'Leveraging modern development tools to streamline workflow and collaboration.',
        skills: [
          SkillProgress(name: 'Git', percentage: 0.90),
          SkillProgress(name: 'GitHub', percentage: 0.92),
          SkillProgress(name: 'VS Code', percentage: 0.95),
          SkillProgress(name: 'Android Studio', percentage: 0.90),
          SkillProgress(name: 'Postman', percentage: 0.85),
          SkillProgress(name: 'Linux', percentage: 0.75),
        ],
      ),
      SkillCard(
        title: 'Cloud & DevOps',
        icon: Icons.cloud_queue_rounded,
        accentColor: const Color(0xFFF7B91C),
        description: 'Actively learning cloud infrastructure and automation practices.',
        skills: [
          SkillProgress(name: 'Docker', percentage: 0.40),
          SkillProgress(name: 'AWS', percentage: 0.35),
          SkillProgress(name: 'CI/CD', percentage: 0.50),
          SkillProgress(name: 'Firebase Hosting', percentage: 0.85),
        ],
      ),
    ];

    final filteredCards = selectedCategory == 'All'
        ? allCards
        : allCards.where((card) => card.title.contains(selectedCategory)).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1000 ? 2 : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 32,
            mainAxisSpacing: 32,
            mainAxisExtent: 380,
          ),
          itemCount: filteredCards.length,
          itemBuilder: (context, index) {
            return filteredCards[index]
                .animate()
                .fadeIn(delay: (index * 150).ms, duration: 600.ms)
                .slideY(begin: 0.1, end: 0);
          },
        );
      },
    );
  }

  Widget _buildCurrentlyLearning() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Currently Learning',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 24,
          runSpacing: 24,
          children: [
            _learningChip('AWS', Icons.cloud_circle_rounded, const Color(0xFFFF9900)),
            _learningChip('Docker', Icons.directions_boat_rounded, const Color(0xFF2496ED)),
            _learningChip('Kubernetes', Icons.anchor_rounded, const Color(0xFF326CE5)),
            _learningChip('Terraform', Icons.grid_on_rounded, const Color(0xFF7B42BC)),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _learningChip(String name, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 12),
          const SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(Colors.white30),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, String title, Widget destination, {bool isSelected = false}) {
    return TextButton(
      onPressed: isSelected ? null : () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => destination,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            settings: RouteSettings(name: title),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? const Color(0xFF6C63FF) : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _AnimatedDivider extends StatelessWidget {
  const _AnimatedDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      width: 100,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF00D2FF)],
        ),
        borderRadius: BorderRadius.circular(1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
     .shimmer(duration: 2000.ms, color: Colors.white);
  }
}

class _BackgroundMesh extends StatelessWidget {
  const _BackgroundMesh();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -100,
          right: -100,
          child: _GlowBlob(color: const Color(0xFF6C63FF).withOpacity(0.1), size: 500),
        ),
        Positioned(
          bottom: -200,
          left: -100,
          child: _GlowBlob(color: const Color(0xFF00D2FF).withOpacity(0.1), size: 600),
        ),
        const _DeveloperGrid(),
      ],
    );
  }
}

class _GlowBlob extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowBlob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 100,
            spreadRadius: 50,
          ),
        ],
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
     .moveY(begin: -20, end: 20, duration: 4000.ms)
     .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 4000.ms);
  }
}

class _DeveloperGrid extends StatelessWidget {
  const _DeveloperGrid();

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.03,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/grid.png'), // Fallback if image not found
            repeat: ImageRepeat.repeat,
            onError: (_, __) {},
          ),
        ),
        child: CustomPaint(
          size: Size.infinite,
          painter: _GridPainter(),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 0.5;

    const step = 40.0;
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
