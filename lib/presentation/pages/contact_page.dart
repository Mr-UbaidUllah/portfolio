import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/contact_form.dart';
import '../widgets/footer.dart';
import '../widgets/available_badge.dart';
import 'portfolio_home_page.dart';
import 'projects_page.dart';
import 'experience_page.dart';
import 'skills_page.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final show = _scrollController.offset > 400;
      if (show != _showBackToTop) {
        setState(() {
          _showBackToTop = show;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF02020A),
      drawer: isMobile ? const CustomDrawer() : null,
      floatingActionButton: _showBackToTop
          ? FloatingActionButton(
              onPressed: () => _scrollController.animateTo(0,
                  duration: 800.ms, curve: Curves.easeInOut),
              backgroundColor: const Color(0xFF6C63FF),
              child: const Icon(Icons.arrow_upward, color: Colors.white),
            ).animate().scale().fadeIn()
          : null,
      body: Stack(
        children: [
          // Background Effects
          const _BackgroundEffects(),
          
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildAppBar(context, isMobile, _scaffoldKey),
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 80),
                          _buildHeader(),
                          const SizedBox(height: 80),
                          
                          // Main Content: Two Columns
                          if (isMobile)
                            Column(
                              children: [
                                _buildIntroSection(),
                                const SizedBox(height: 60),
                                const ContactForm(),
                              ],
                            )
                          else
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _buildIntroSection()),
                                const SizedBox(width: 80),
                                const Expanded(child: ContactForm()),
                              ],
                            ),
                          
                          const SizedBox(height: 100),
                          _buildContactCardsGrid(isMobile),
                          const SizedBox(height: 100),
                          _buildCTACard(isMobile),
                          const SizedBox(height: 100),
                          _buildSocialSection(),
                          const SizedBox(height: 100),
                          const Footer(),
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

  Widget _buildAppBar(BuildContext context, bool isMobile, GlobalKey<ScaffoldState> key) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: const Color(0xFF02020A).withValues(alpha: 0.8),
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(color: Colors.transparent),
        ),
      ),
      title: Row(
        children: [
          if (isMobile)
            IconButton(
              icon: const Icon(Icons.menu, color: Color(0xFF6C63FF)),
              onPressed: () => key.currentState?.openDrawer(),
            ),
          const SizedBox(width: 20),
          const Text(
            'Ubaid Ullah',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
        ],
      ),
      actions: [
        if (!isMobile) ...[
          _navItem(context, 'Home', const PortfolioHomePage()),
          _navItem(context, 'Projects', const ProjectsPage()),
          _navItem(context, 'Experience', const ExperiencePage()),
          _navItem(context, 'Skills', const SkillsPage()),
          _navItem(context, 'Contact', const ContactPage(), isSelected: true),
          const SizedBox(width: 40),
        ],
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          "Let's Work Together",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.w900,
            height: 1.1,
            color: Colors.white,
            letterSpacing: -2,
          ),
        ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, curve: Curves.easeOutQuad),
        const SizedBox(height: 24),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Text(
            "Have an idea, a project, or an opportunity? I'd love to hear from you. Let's build something amazing together.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withValues(alpha: 0.6),
              height: 1.6,
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 800.ms),
        ),
        const SizedBox(height: 40),
        Container(
          width: 80,
          height: 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: const LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF00FF94)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6C63FF).withValues(alpha: 0.5),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
        ).animate().scaleX(begin: 0, duration: 1000.ms, curve: Curves.easeOutBack),
      ],
    );
  }

  Widget _buildIntroSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AvailableBadge().animate().fadeIn(delay: 400.ms),
        const SizedBox(height: 32),
        const Text(
          "Professional\nCollaboration",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.2,
          ),
        ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.1),
        const SizedBox(height: 24),
        Text(
          "I specialize in building high-quality mobile and web applications with a focus on performance, scalability, and exceptional user experience.",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.6),
            height: 1.6,
          ),
        ).animate().fadeIn(delay: 600.ms),
        const SizedBox(height: 40),
        _buildAvailabilityItem("Available for Freelance", true),
        _buildAvailabilityItem("Open to Full-Time Opportunities", true),
        _buildAvailabilityItem("Open Source Collaboration", true),
        const SizedBox(height: 48),
        // Illustration or Graphic Placeholder
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [
                const Color(0xFF6C63FF).withValues(alpha: 0.05),
                const Color(0xFF00FF94).withValues(alpha: 0.05),
              ],
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Center(
            child: Icon(
              Icons.code_rounded,
              size: 80,
              color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
            ),
          ),
        ).animate(onPlay: (c) => c.repeat(reverse: true))
         .moveY(begin: -10, end: 10, duration: 2.seconds, curve: Curves.easeInOut),
      ],
    );
  }

  Widget _buildAvailabilityItem(String text, bool available) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: available ? const Color(0xFF00FF94) : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCardsGrid(bool isMobile) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isMobile ? 1 : 3,
      crossAxisSpacing: 24,
      mainAxisSpacing: 24,
      childAspectRatio: isMobile ? 2.5 : 1.5,
      children: [
        _buildContactCard(
          Icons.email_outlined,
          "Email",
          "ubaidullah.dev09@gmail.com",
          () => _launchUrl('mailto:ubaidullah.dev09@gmail.com'),
        ),
        _buildContactCard(
          Icons.phone_outlined,
          "Phone",
          "+92 312 3456789",
          () => _launchUrl('tel:+923123456789'),
        ),
        _buildContactCard(
          Icons.location_on_outlined,
          "Location",
          "Islamabad, Pakistan",
          null,
        ),
      ],
    );
  }

  Widget _buildContactCard(IconData icon, String title, String info, VoidCallback? onTap) {
    return _HoverCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF6C63FF), size: 32),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              info,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCTACard(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 32 : 60),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF0F0F1E)],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          const Text(
            "Ready to build something exceptional?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Whether it's a mobile application, full-stack solution, UI/UX design, or an innovative idea, let's make it happen together.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.6),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildCTAButton("Hire Me", Icons.work_outline, true, () {}),
              _buildCTAButton("Download Resume", Icons.download_rounded, false, () {}),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.1);
  }

  Widget _buildCTAButton(String text, IconData icon, bool primary, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: primary ? const Color(0xFF6C63FF) : Colors.transparent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: primary ? BorderSide.none : BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        elevation: primary ? 10 : 0,
        shadowColor: primary ? const Color(0xFF6C63FF).withValues(alpha: 0.4) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 12),
          Icon(icon, size: 20),
        ],
      ),
    );
  }

  Widget _buildSocialSection() {
    return Column(
      children: [
        Text(
          "Connect on Social Media",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 24,
          runSpacing: 24,
          children: [
            _buildSocialButton("GitHub", () => _launchUrl('https://github.com/Mr-UbaidUllah')),
            _buildSocialButton("LinkedIn", () => _launchUrl('https://linkedin.com/in/ubaid-ullah')),
            _buildSocialButton("Twitter", () => _launchUrl('https://twitter.com')),
            _buildSocialButton("Instagram", () => _launchUrl('https://instagram.com')),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(String label, VoidCallback onTap) {
    return _HoverCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
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

class _HoverCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  const _HoverCard({required this.child, this.onTap});

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          transform: _isHovered ? Matrix4.translationValues(0, -8, 0) : Matrix4.identity(),
          decoration: BoxDecoration(
            color: _isHovered ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _isHovered ? const Color(0xFF6C63FF).withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.05),
            ),
            boxShadow: _isHovered ? [
              BoxShadow(
                color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
                blurRadius: 30,
                spreadRadius: 5,
              )
            ] : [],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class _BackgroundEffects extends StatelessWidget {
  const _BackgroundEffects();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        // Top right glow
        Positioned(
          top: -200,
          right: -100,
          child: Container(
            width: 600,
            height: 600,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF6C63FF).withValues(alpha: 0.05),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
        // Middle left glow
        Positioned(
          top: size.height * 0.4,
          left: -150,
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF00FF94).withValues(alpha: 0.03),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
        // Bottom right glow
        Positioned(
          bottom: -100,
          right: -50,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF6C63FF).withValues(alpha: 0.04),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
      ],
    );
  }
}
