import 'package:flutter/material.dart';
import 'presentation/pages/portfolio_home_page.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      ),
      home: const PortfolioHomePage(),
    );
  }
}
