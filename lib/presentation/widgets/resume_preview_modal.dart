import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ResumePreviewModal extends StatelessWidget {
  const ResumePreviewModal({super.key});

  static void show(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close Resume Preview',
      barrierColor: Colors.black.withValues(alpha: 0.8),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const ResumePreviewModal();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10 * animation.value, sigmaY: 10 * animation.value),
          child: FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 800;

    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
          Navigator.of(context).pop();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 1000,
              maxHeight: size.height * 0.9,
            ),
            margin: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A).withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 50,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Column(
                children: [
                  _buildHeader(context),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(isMobile ? 24 : 48),
                      child: isMobile 
                        ? Column(children: _buildContent(context, true))
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 3, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: _buildContent(context, false))),
                              const SizedBox(width: 48),
                              Expanded(flex: 2, child: _buildPreviewPlaceholder()),
                            ],
                          ),
                    ),
                  ),
                  _buildFooter(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.description_outlined, color: Color(0xFF6C63FF)),
              SizedBox(width: 12),
              Text(
                'Resume Preview',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white60),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Close (Esc)',
          ),
        ],
      ),
    );
  }

  List<Widget> _buildContent(BuildContext context, bool isMobile) {
    return [
      const Text(
        'Ubaid Ullah',
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white),
      ),
      const Text(
        'Senior Flutter Developer',
        style: TextStyle(fontSize: 18, color: Color(0xFF6C63FF), fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 24),
      _buildSection('Profile Summary', 'Dynamic and results-driven Senior Flutter Developer with 3+ years of experience in building high-performance mobile and web applications. Expert in Dart, Riverpod, and Clean Architecture.'),
      const SizedBox(height: 24),
      _buildSection('Skills Overview', '• Flutter & Dart Expert\n• State Management (Riverpod, Bloc, Provider)\n• Firebase & Cloud Integration\n• CI/CD & DevOps\n• UI/UX Design & Animations'),
      const SizedBox(height: 24),
      _buildSection('Experience Highlights', '• Built multi-tenant Flutter apps for 1M+ users.\n• Achieved 60 FPS on low-end devices via performance optimization.\n• Led cross-functional teams to deliver production-ready apps.'),
      const SizedBox(height: 24),
      _buildSection('Education & Certifications', '• BS in Computer Science - University of Peshawar \n• Google Certified Flutter Developer\n• Advanced UI/UX Design Certification'),
      if (isMobile) ...[
        const SizedBox(height: 32),
        _buildPreviewPlaceholder(),
      ],
    ];
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white38, letterSpacing: 1.2),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(fontSize: 15, color: Colors.white.withValues(alpha: 0.7), height: 1.5),
        ),
      ],
    );
  }

  Widget _buildPreviewPlaceholder() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.picture_as_pdf_rounded, size: 64, color: Colors.redAccent.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            const Text('ubaidullah_CV.pdf', style: TextStyle(color: Colors.white38)),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close', style: TextStyle(color: Colors.white60)),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () async {
              final Uri url = Uri.parse('assets/docs/ubaidullah_CV.pdf');
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                debugPrint('Could not launch $url');
              }
            },
            icon: const Icon(Icons.download_rounded),
            label: const Text('Download Resume'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}
