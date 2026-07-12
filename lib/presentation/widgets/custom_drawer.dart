import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../pages/portfolio_home_page.dart';
import '../pages/projects_page.dart';
import '../pages/experience_page.dart';
import '../pages/skills_page.dart';
import '../pages/contact_page.dart';

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
    return Drawer(
      backgroundColor: const Color(0xFF0D0D1E),
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white10)),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF6C63FF),
                            width: 2,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/3D Developer Avatar.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                      .animate()
                      .scale(duration: 600.ms, curve: Curves.easeOutBack)
                      .fadeIn(),
                  const SizedBox(height: 12),
                  const Text(
                    'Ubaid Ullah',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                  const SizedBox(height: 4),
                  Text(
                    'Flutter Developer',
                    style: TextStyle(
                      color: Colors.white.withAlpha((0.6 * 255).toInt()),
                      fontSize: 12,
                    ),
                  ).animate().fadeIn(delay: 400.ms),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              itemExtent: 65,
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: [
                _buildDrawerItem(
                  context,
                  'assets/images/drawer_home.png',
                  'Home',
                  const PortfolioHomePage(),
                  0,
                ),
                _buildDrawerItem(
                  context,
                  'assets/images/drawer_project.png',
                  'Projects',
                  const ProjectsPage(),
                  1,
                ),
                _buildDrawerItem(
                  context,
                  'assets/images/drawer_experience.png',
                  'Experience',
                  const ExperiencePage(),
                  2,
                ),
                _buildDrawerItem(
                  context,
                  'assets/images/drawer_skill.png',
                  'Skills',
                  const SkillsPage(),
                  3,
                ),
                _buildDrawerItem(
                  context,
                  'assets/images/drawer_contact.png',
                  'Contact',
                  const ContactPage(),
                  4,
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white10),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSocialIcon(
                  Icons.link,
                  0,
                  () => _launchUrl('https://www.linkedin.com/in/ubaid-ullah'),
                ),
                _buildSocialIcon(
                  Icons.code,
                  1,
                  () => _launchUrl('https://github.com/Mr-UbaidUllah'),
                ),
                _buildSocialIcon(
                  Icons.alternate_email,
                  2,
                  () => _launchUrl('mailto:ubaidullah.dev09@gmail.com'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    String imagePath,
    String title,
    Widget destination,
    int index,
  ) {
    final isSelected =
        ModalRoute.of(context)?.settings.name == null && title == 'Home' ||
        ModalRoute.of(context)?.settings.name == title;

    return InkWell(
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    destination,
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                settings: RouteSettings(name: title),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: isSelected
                    ? [
                        const Color(0xFF6C63FF).withAlpha((0.2 * 255).toInt()),
                        const Color(0xFF0D0D1E),
                      ]
                    : [const Color(0xFF0D0D1E), const Color(0xFF0D0D1E)],
              ),
            ),
            child: Row(
              children: [
                Image.asset(
                  imagePath,
                  height: 22,
                  width: 22,
                  color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                    fontSize: 15,
                    fontFamily: 'regular',
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(delay: (100 * index).ms, duration: 400.ms)
        .slideX(begin: -0.1, end: 0);
  }

  Widget _buildSocialIcon(IconData icon, int index, VoidCallback onTap) {
    return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white10),
            ),
            child: Icon(icon, color: Colors.white38, size: 20),
          ),
        )
        .animate()
        .fadeIn(delay: (600 + (100 * index)).ms)
        .scale(curve: Curves.elasticOut);
  }
}
