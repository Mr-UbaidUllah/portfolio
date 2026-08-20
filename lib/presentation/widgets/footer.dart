import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/app_breakpoints.dart';

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
    final size = MediaQuery.of(context).size;
    final isMobile = AppBreakpoints.isMobile(size.width);

    return Semantics(
      container: true,
      label: 'Footer section',
      child: Column(
        children: [
          Divider(
            color: Colors.white.withValues(alpha: 0.05),
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: isMobile
                  ? Column(
                      children: [
                        _buildCopyright(),
                        const SizedBox(height: 24),
                        _buildLinks(),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCopyright(),
                        _buildLinks(),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCopyright() {
    return const Text(
      '© 2026 Ubaid Ullah. Peshawar, Pakistan – open to remote.',
      style: TextStyle(
        color: Color(0xFF6E82A6),
        fontSize: 13,
        fontWeight: FontWeight.w400,
        fontFamily: 'monospace',
      ),
    );
  }

  Widget _buildLinks() {
    return Wrap(
      spacing: 24,
      runSpacing: 12,
      children: [
        _FooterLink(
          label: 'Email',
          onTap: () => _launchUrl('mailto:ubaidullah.dev09@gmail.com'),
        ),
        _FooterLink(
          label: '+92 318 4445488',
          onTap: () => _launchUrl('tel:+923184445488'),
        ),
        _FooterLink(
          label: 'LinkedIn',
          onTap: () => _launchUrl(
              'https://www.linkedin.com/in/ubaid-ullah-84b442285/'),
        ),
        _FooterLink(
          label: 'GitHub',
          onTap: () => _launchUrl('https://github.com/Mr-UbaidUllah'),
        ),
      ],
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _FooterLink({required this.label, required this.onTap});

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        child: Text(
          widget.label,
          style: TextStyle(
            color: _isHovered ? Colors.white : const Color(0xFF6E82A6),
            fontSize: 13,
            fontWeight: FontWeight.w400,
            fontFamily: 'monospace',
          ),
        ),
      ),
    );
  }
}
