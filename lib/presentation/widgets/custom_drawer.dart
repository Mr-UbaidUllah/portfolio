import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final bool reduceMotion = MediaQuery.of(context).accessibleNavigation || 
                             MediaQuery.of(context).disableAnimations;

    return Drawer(
      backgroundColor: const Color(0xFF0D0D1E),
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(reduceMotion),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 20),
                children: [
                  _buildDrawerItem(
                    context,
                    Icons.home_outlined,
                    'Home',
                    '/home',
                    location == '/home',
                    0,
                    reduceMotion,
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.code_rounded,
                    'Projects',
                    '/projects',
                    location == '/projects',
                    1,
                    reduceMotion,
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.work_outline_rounded,
                    'Experience',
                    '/experience',
                    location == '/experience',
                    2,
                    reduceMotion,
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.psychology_outlined,
                    'Skills',
                    '/skills',
                    location == '/skills',
                    3,
                    reduceMotion,
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.alternate_email_rounded,
                    'Contact',
                    '/contact',
                    location == '/contact',
                    4,
                    reduceMotion,
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white10),
            _buildSocialSection(reduceMotion),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool reduceMotion) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFF6C63FF),
                  width: 2,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: ClipOval(
                child: Semantics(
                  label: 'Ubaid Ullah Avatar',
                  child: Image.asset(
                    'assets/images/profileImage.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, _, __) => const Icon(Icons.person, color: Colors.white24, size: 40),
                  ),
                ),
              ),
            )
            .animate()
            .scale(duration: reduceMotion ? 0.ms : 600.ms, curve: Curves.easeOutBack)
            .fadeIn(duration: reduceMotion ? 0.ms : 600.ms),
            const SizedBox(height: 16),
            const Text(
              'Ubaid Ullah',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ).animate().fadeIn(delay: reduceMotion ? 0.ms : 200.ms).slideY(begin: reduceMotion ? 0 : 0.2),
            const SizedBox(height: 4),
            const Text(
              'Flutter Developer',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 14,
                letterSpacing: 1,
              ),
            ).animate().fadeIn(delay: reduceMotion ? 0.ms : 400.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    String routePath,
    bool isSelected,
    int index,
    bool reduceMotion,
  ) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isHovered = false;
        return Focus(
          onFocusChange: (focused) => setState(() => isHovered = focused),
          child: MouseRegion(
            onEnter: (_) => setState(() => isHovered = true),
            onExit: (_) => setState(() => isHovered = false),
            child: Semantics(
              button: true,
              selected: isSelected,
              label: 'Navigate to $title',
              child: ListTile(
                onTap: () {
                  Navigator.pop(context);
                  context.go(routePath);
                },
                leading: Icon(
                  icon,
                  color: isSelected || isHovered ? const Color(0xFF6C63FF) : Colors.white38,
                ),
                title: Text(
                  title,
                  style: TextStyle(
                    color: isSelected || isHovered ? Colors.white : Colors.white60,
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                tileColor: isSelected ? const Color(0xFF6C63FF).withValues(alpha: 0.05) : Colors.transparent,
              ),
            ),
          ),
        );
      }
    ).animate()
     .fadeIn(delay: reduceMotion ? 0.ms : (100 * index).ms, duration: reduceMotion ? 0.ms : 400.ms)
     .slideX(begin: reduceMotion ? 0 : -0.1, end: 0);
  }

  Widget _buildSocialSection(bool reduceMotion) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _SocialIconButton(
            icon: Icons.link,
            index: 0,
            onTap: () => _launchUrl('https://www.linkedin.com/in/ubaid-ullah'),
            reduceMotion: reduceMotion,
            tooltip: 'LinkedIn',
          ),
          _SocialIconButton(
            icon: Icons.code,
            index: 1,
            onTap: () => _launchUrl('https://github.com/Mr-UbaidUllah'),
            reduceMotion: reduceMotion,
            tooltip: 'GitHub',
          ),
          _SocialIconButton(
            icon: Icons.alternate_email,
            index: 2,
            onTap: () => _launchUrl('mailto:ubaidullah.dev09@gmail.com'),
            reduceMotion: reduceMotion,
            tooltip: 'Email',
          ),
        ],
      ),
    );
  }
}

class _SocialIconButton extends StatefulWidget {
  final IconData icon;
  final int index;
  final VoidCallback onTap;
  final bool reduceMotion;
  final String tooltip;

  const _SocialIconButton({
    required this.icon,
    required this.index,
    required this.onTap,
    required this.reduceMotion,
    required this.tooltip,
  });

  @override
  State<_SocialIconButton> createState() => _SocialIconButtonState();
}

class _SocialIconButtonState extends State<_SocialIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focused) => setState(() => _isHovered = focused),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Tooltip(
          message: widget.tooltip,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(25),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(12),
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isHovered ? const Color(0xFF6C63FF).withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.03),
                border: Border.all(
                  color: _isHovered ? const Color(0xFF6C63FF).withValues(alpha: 0.5) : Colors.white10,
                ),
                boxShadow: _isHovered ? [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ] : null,
              ),
              child: Icon(
                widget.icon,
                color: _isHovered ? Colors.white : Colors.white38,
                size: 22,
              ),
            ),
          ),
        ),
      ),
    ).animate()
     .fadeIn(delay: widget.reduceMotion ? 0.ms : (600 + (100 * widget.index)).ms, duration: widget.reduceMotion ? 0.ms : 400.ms)
     .scale(curve: Curves.elasticOut, begin: widget.reduceMotion ? const Offset(1, 1) : const Offset(0, 0));
  }
}
