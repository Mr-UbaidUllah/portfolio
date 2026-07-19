import 'package:flutter/material.dart';
import 'core/app_router.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Ubaid Ullah Portfolio',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF02020A),
        fontFamily: 'regular',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'bold'),
          displayMedium: TextStyle(fontFamily: 'bold'),
          displaySmall: TextStyle(fontFamily: 'bold'),
          headlineLarge: TextStyle(fontFamily: 'bold'),
          headlineMedium: TextStyle(fontFamily: 'bold'),
          headlineSmall: TextStyle(fontFamily: 'bold'),
          titleLarge: TextStyle(fontFamily: 'bold'),
          titleMedium: TextStyle(
            fontFamily: 'bold',
            fontWeight: FontWeight.bold,
          ),
          titleSmall: TextStyle(fontFamily: 'bold'),
          bodyLarge: TextStyle(fontFamily: 'regular'),
          bodyMedium: TextStyle(fontFamily: 'regular'),
          bodySmall: TextStyle(fontFamily: 'regular'),
        ),
        // Adding a default focus theme for keyboard accessibility
        focusColor: const Color(0xFF6C63FF).withValues(alpha: 0.3),
      ),
      routerConfig: AppRouter.router,
    );
  }
}
