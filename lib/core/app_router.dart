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
          return PortfolioScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const PortfolioHomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/projects',
                builder: (context, state) => const ProjectsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/experience',
                builder: (context, state) => const ExperiencePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/skills',
                builder: (context, state) => const SkillsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/contact',
                builder: (context, state) => const ContactPage(),
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
    // This scaffold will host the navigation shell.
    // The individual pages still contain their own AppBars to preserve the existing UI design.
    return Scaffold(
      body: navigationShell,
    );
  }
}
