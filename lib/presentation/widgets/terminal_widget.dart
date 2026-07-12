import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TerminalWidget extends StatefulWidget {
  const TerminalWidget({super.key});

  @override
  State<TerminalWidget> createState() => _TerminalWidgetState();
}

class _TerminalWidgetState extends State<TerminalWidget> {
  final List<TerminalLine> _lines = [
    TerminalLine(command: 'whoami', response: 'Ubaid Ullah — Full Stack Flutter Developer'),
    TerminalLine(command: 'ls --skills', response: 'Flutter, Dart, Firebase, Node.js, AWS, Git'),
    TerminalLine(command: 'status', response: 'Building modern experiences 🚀'),
    TerminalLine(command: 'contact', response: 'ubaidullah.dev09@gmail.com'),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: 480,
          height: 320,
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A).withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
              BoxShadow(
                color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                blurRadius: 20,
                spreadRadius: -5,
              ),
            ],
          ),
          child: Column(
            children: [
              // Terminal Header (macOS style)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  border: Border(
                    bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                ),
                child: Row(
                  children: [
                    _dot(const Color(0xFFFF5F56)),
                    const SizedBox(width: 8),
                    _dot(const Color(0xFFFFBD2E)),
                    const SizedBox(width: 8),
                    _dot(const Color(0xFF27C93F)),
                    Expanded(
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.terminal, size: 14, color: Colors.white38),
                            const SizedBox(width: 8),
                            const Text(
                              'zsh — ubaid2portfolio',
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'monospace',
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Balance for dots
                  ],
                ),
              ),
              // Terminal Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView.builder(
                    itemCount: _lines.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _lines.length) {
                        return const _ActiveCursorLine();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: _buildCommandLine(_lines[index], index),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildCommandLine(TerminalLine line, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '➜ ',
              style: TextStyle(
                color: Color(0xFF818CF8),
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                fontSize: 14,
              ),
            ),
            const Text(
              '~ ',
              style: TextStyle(
                color: Color(0xFF34D399),
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Expanded(
              child: Animate(
                delay: (index * 1500).ms,
                effects: [
                  CustomEffect(
                    duration: (line.command.length * 50).ms,
                    builder: (context, value, child) {
                      final length = (value * line.command.length).floor();
                      return Text(
                        line.command.substring(0, length),
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'monospace',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Animate(
          delay: (index * 1500 + 700).ms,
          effects: [
            FadeEffect(duration: 400.ms),
            const SlideEffect(begin: Offset(0, 0.1), end: Offset.zero),
          ],
          child: Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: Text(
              line.response,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontFamily: 'monospace',
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 4,
          ),
        ],
      ),
    );
  }
}

class TerminalLine {
  final String command;
  final String response;

  TerminalLine({required this.command, required this.response});
}

class _ActiveCursorLine extends StatelessWidget {
  const _ActiveCursorLine();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          '➜ ',
          style: TextStyle(
            color: Color(0xFF818CF8),
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
        const Text(
          '~ ',
          style: TextStyle(
            color: Color(0xFF34D399),
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Container(
          width: 8,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.2),
                blurRadius: 4,
              ),
            ],
          ),
        ).animate(onPlay: (c) => c.repeat())
         .fadeIn(duration: 500.ms)
         .fadeOut(delay: 500.ms, duration: 500.ms),
      ],
    ).animate(delay: 6.seconds).fadeIn();
  }
}
