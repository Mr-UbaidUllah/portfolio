import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
      child: Column(
        children: [
          const Text(
            '© 2024 UBAID ULLAH. CRAFTED WITH PRECISION.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white38,
              fontSize: 12,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFooterLink(
                'LINKEDIN',
                onTap: () => _launchUrl(
                  'https://www.linkedin.com/in/ubaid-ullah',
                ), // Replace with your link
              ),
              const SizedBox(width: 24),
              _buildFooterLink(
                'GITHUB',
                onTap: () => _launchUrl(
                  'https://github.com/Mr-UbaidUllah',
                ), // Replace with your username
              ),
              const SizedBox(width: 24),
              _buildFooterLink(
                'EMAIL',
                onTap: () => _launchUrl(
                  'mailto:ubaidullah.dev09@gmail.com',
                ), // Replace with your email
              ),
              const SizedBox(width: 15),
              IconButton(
                padding: EdgeInsets.all(10),
                constraints: BoxConstraints(),
                color: Color(0xFF6C63FF),
                icon: const Icon(
                  Icons.arrow_upward,
                  size: 15,
                  color: Colors.white38,
                ),
                onPressed: () {
                  Scrollable.ensureVisible(
                    context,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String label, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}
