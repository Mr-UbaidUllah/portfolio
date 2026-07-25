import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/pages/splash_screen.dart';
import '../presentation/pages/portfolio_home_page.dart';
import '../presentation/pages/projects_page.dart';
import '../presentation/pages/experience_page.dart';
import '../presentation/pages/skills_page.dart';
import '../presentation/pages/contact_page.dart';

class AppRouter {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final shellNavigatorKey = GlobalKey<NavigatorState>();

  static Widget _withTitle(String title, Widget child) {
    return Title(
      title: '$title | Ubaid Ullah',
      color: const Color(0xFF6C63FF),
      child: child,
    );
  }

  static final router = GoRouter(
    initialLocation: '/',
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // Fixed: Removed unnecessary outer Scaffold to avoid nested Scaffolds
          // which can cause issues with drawers, snackbars, and focus management.
          return PortfolioScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => _withTitle('Home', const PortfolioHomePage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/projects',
                builder: (context, state) => _withTitle('Projects', const ProjectsPage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/experience',
                builder: (context, state) => _withTitle('Experience', const ExperiencePage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/skills',
                builder: (context, state) => _withTitle('Skills', const SkillsPage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/contact',
                builder: (context, state) => _withTitle('Contact', const ContactPage()),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class PortfolioScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const PortfolioScaffold({
    required this.navigationShell,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Fixed: Just return navigationShell. Nested Scaffolds are a common source of UI bugs.
    return navigationShell;
  }
}
