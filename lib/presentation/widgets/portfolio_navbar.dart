import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_breakpoints.dart';
import 'nav_item.dart';

class PortfolioNavbar extends StatelessWidget {
  final bool isMobile;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const PortfolioNavbar({
    required this.isMobile,
    this.scaffoldKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    return SliverAppBar(
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
      ),
      leading: isMobile
          ? IconButton(
              icon: const Icon(Icons.menu, color: Color(0xFF6C63FF)),
              onPressed: () => scaffoldKey?.currentState?.openDrawer(),
              tooltip: 'Open Menu',
            )
          : null,
      title: Padding(
        padding: EdgeInsets.only(left: isMobile ? 0 : 40),
        child: InkWell(
          onTap: () => context.go('/home'),
          borderRadius: BorderRadius.circular(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF00FF94),
                  shape: BoxShape.circle,
                ),
              ).animate(onPlay: (c) => c.repeat()).scale(begin: const Offset(1, 1), end: const Offset(2, 2), duration: 1.seconds).fadeOut(),
              const SizedBox(width: 12),
              const Text(
                'UBAID',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  letterSpacing: 2,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 800.ms).slideX(begin: -0.2),
      ),
      actions: [
        if (!isMobile) ...[
          NavItem(title: 'Home', routePath: '/home', isSelected: location == '/home'),
          NavItem(title: 'Projects', routePath: '/projects', isSelected: location == '/projects'),
          NavItem(title: 'Experience', routePath: '/experience', isSelected: location == '/experience'),
          NavItem(title: 'Skills', routePath: '/skills', isSelected: location == '/skills'),
          NavItem(title: 'Contact', routePath: '/contact', isSelected: location == '/contact'),
          const SizedBox(width: 40),
        ],
      ],
    );
  }
}
