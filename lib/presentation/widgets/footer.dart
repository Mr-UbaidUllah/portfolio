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
    return Semantics(
      container: true,
      label: 'Footer section',
      child: Padding(
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
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                _FooterLink(
                  label: 'LINKEDIN',
                  onTap: () => _launchUrl('https://www.linkedin.com/in/ubaid-ullah-84b442285/'),
                ),
                _FooterLink(
                  label: 'GITHUB',
                  onTap: () => _launchUrl('https://github.com/Mr-UbaidUllah'),
                ),
                _FooterLink(
                  label: 'EMAIL',
                  onTap: () => _launchUrl('mailto:ubaidullah.dev09@gmail.com'),
                ),
                const SizedBox(width: 15),
                _BackToTopButton(),
              ],
            ),
          ],
        ),
      ),
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
    return Focus(
      onFocusChange: (focused) => setState(() => _isHovered = focused),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              widget.label,
              style: TextStyle(
                color: _isHovered ? Colors.white : Colors.white38,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.1,
                decoration: _isHovered ? TextDecoration.underline : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BackToTopButton extends StatefulWidget {
  @override
  State<_BackToTopButton> createState() => _BackToTopButtonState();
}

class _BackToTopButtonState extends State<_BackToTopButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focused) => setState(() => _isHovered = focused),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: SizedBox(
          width: 48,
          height: 48,
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: 'Back to top',
            icon: Icon(
              Icons.arrow_upward,
              size: 18,
              color: _isHovered ? Colors.white : Colors.white38,
            ),
            onPressed: () {
              final scrollable = Scrollable.of(context);
              scrollable.position.animateTo(
                0,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOutCubic,
              );
            },
          ),
        ),
      ),
    );
  }
}
