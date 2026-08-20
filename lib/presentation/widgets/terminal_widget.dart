// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:go_router/go_router.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'resume_preview_modal.dart';
//
// class TerminalWidget extends StatefulWidget {
//   const TerminalWidget({super.key});
//
//   @override
//   State<TerminalWidget> createState() => _TerminalWidgetState();
// }
//
// class _TerminalWidgetState extends State<TerminalWidget> {
//   final List<TerminalLineData> _history = [
//     TerminalLineData(command: 'whoami', response: 'Ubaid Ullah'),
//     TerminalLineData(command: 'role', response: 'Flutter Developer • Full-Stack Developer • UI/UX Designer'),
//     TerminalLineData(command: 'stack', response: 'Flutter • Dart • Firebase • Node.js • TypeScript'),
//     TerminalLineData(command: 'status', response: 'Available for Work'),
//   ];
//
//   final TextEditingController _inputController = TextEditingController();
//   final FocusNode _focusNode = FocusNode();
//   final ScrollController _scrollController = ScrollController();
//   final List<String> _commandHistory = [];
//   int _historyIndex = -1;
//
//   @override
//   void dispose() {
//     _inputController.dispose();
//     _focusNode.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   void _handleCommand(String input) {
//     final cmd = input.trim().toLowerCase();
//     if (cmd.isEmpty) return;
//
//     _commandHistory.insert(0, input);
//     _historyIndex = -1;
//     String response = '';
//     bool clear = false;
//
//     if (cmd == 'help') {
//       response = 'Available commands: help, updates, about, skills, projects, experience, contact, resume, github, linkedin, clear, ls, pwd, whoami, role, stack, status, cat [file]';
//     } else if (cmd == 'updates' || cmd == 'changelog') {
//       response = '''
// [LATEST UPDATES]
// • OPTIMIZED: Home Screen information hierarchy for recruiters.
// • ADDED: Credibility stats and technology stack preview.
// • IMPROVED: CTA hierarchy and mobile responsiveness.
// • UPDATED: Social link accessibility and hit targets.''';
//     } else if (cmd == 'about') {
//       response = 'I am a Flutter-focused developer dedicated to building high-performance mobile and web applications with clean architecture and premium UI.';
//     } else if (cmd == 'skills' || cmd == 'ls skills') {
//       context.go('/skills');
//       response = 'Navigating to Skills...';
//     } else if (cmd == 'projects' || cmd == 'ls projects') {
//       context.go('/projects');
//       response = 'Navigating to Projects...';
//     } else if (cmd == 'experience') {
//       context.go('/experience');
//       response = 'Navigating to Experience...';
//     } else if (cmd == 'contact') {
//       context.go('/contact');
//       response = 'Navigating to Contact...';
//     } else if (cmd == 'resume') {
//       response = 'Opening Resume Preview...';
//       ResumePreviewModal.show(context);
//     } else if (cmd == 'github') {
//       _launchUrl('https://github.com/Mr-UbaidUllah');
//       response = 'Opening GitHub profile...';
//     } else if (cmd == 'linkedin') {
//       _launchUrl('https://www.linkedin.com/in/ubaid-ullah');
//       response = 'Opening LinkedIn profile...';
//     } else if (cmd == 'clear') {
//       clear = true;
//     } else if (cmd == 'ls') {
//       response = 'home  projects  experience  skills  contact  resume.pdf';
//     } else if (cmd == 'pwd') {
//       response = '/users/ubaid/portfolio${GoRouterState.of(context).uri.path}';
//     } else if (cmd == 'whoami') {
//       response = 'Ubaid Ullah';
//     } else if (cmd == 'role') {
//       response = 'Flutter Developer • Full-Stack Developer • UI/UX Designer';
//     } else if (cmd == 'stack') {
//       response = 'Flutter • Dart • Firebase • Node.js • TypeScript • MySQL';
//     } else if (cmd == 'status') {
//       response = 'Available for Work';
//     } else if (cmd.startsWith('cat ')) {
//       final file = cmd.substring(4).trim();
//       if (file == 'resume' || file == 'resume.pdf') {
//         ResumePreviewModal.show(context);
//         response = 'Reading resume.pdf...';
//       } else {
//         response = 'cat: $file: No such file or directory';
//       }
//     } else {
//       response = 'zsh: command not found: $cmd. Type "help" for options.';
//     }
//
//     setState(() {
//       if (clear) {
//         _history.clear();
//       } else {
//         _history.add(TerminalLineData(command: input, response: response));
//       }
//       _inputController.clear();
//     });
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   Future<void> _launchUrl(String urlString) async {
//     final Uri url = Uri.parse(urlString);
//     if (!await launchUrl(url)) throw 'Could not launch $url';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Semantics(
//       label: 'Interactive Developer Terminal',
//       child: GestureDetector(
//         onTap: () => _focusNode.requestFocus(),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(16),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
//             child: Container(
//               width: 700,
//               height: 450,
//               decoration: BoxDecoration(
//                 color: const Color(0xFF0F172A).withValues(alpha: 0.85),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1.5),
//                 boxShadow: [
//                   BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 30, offset: const Offset(0, 15)),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   _buildHeader(),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: ListView(
//                         controller: _scrollController,
//                         physics: const BouncingScrollPhysics(),
//                         children: [
//                           ..._history.map((line) => _buildHistoryLine(line)),
//                           _buildInputLine(),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     ).animate().fadeIn().scale(begin: const Offset(0.98, 0.98));
//   }
//
//   Widget _buildHeader() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         color: Colors.white.withValues(alpha: 0.05),
//         border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
//       ),
//       child: Row(
//         children: [
//           _dot(const Color(0xFFFF5F56)),
//           const SizedBox(width: 8),
//           _dot(const Color(0xFFFFBD2E)),
//           const SizedBox(width: 8),
//           _dot(const Color(0xFF27C93F)),
//           const Expanded(
//             child: Center(
//               child: Text(
//                 'ubaid — portfolio — 80x24',
//                 style: TextStyle(color: Colors.white38, fontSize: 11, fontFamily: 'monospace'),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHistoryLine(TerminalLineData line) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             const Text('➜ ', style: TextStyle(color: Color(0xFF818CF8), fontFamily: 'monospace', fontWeight: FontWeight.bold)),
//             const Text('~ ', style: TextStyle(color: Color(0xFF34D399), fontFamily: 'monospace', fontWeight: FontWeight.bold)),
//             Text(line.command, style: const TextStyle(color: Colors.white, fontFamily: 'monospace')),
//           ],
//         ),
//         if (line.response.isNotEmpty)
//           Padding(
//             padding: const EdgeInsets.only(left: 28, top: 4, bottom: 12),
//             child: Text(
//               line.response,
//               style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontFamily: 'monospace', fontSize: 13),
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildInputLine() {
//     return Row(
//       children: [
//         const Text('➜ ', style: TextStyle(color: Color(0xFF818CF8), fontFamily: 'monospace', fontWeight: FontWeight.bold)),
//         const Text('~ ', style: TextStyle(color: Color(0xFF34D399), fontFamily: 'monospace', fontWeight: FontWeight.bold)),
//         const SizedBox(width: 4),
//         Expanded(
//           child: Focus(
//             onKeyEvent: (node, event) {
//               if (event is KeyDownEvent) {
//                 if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
//                   if (_commandHistory.isNotEmpty && _historyIndex < _commandHistory.length - 1) {
//                     setState(() {
//                       _historyIndex++;
//                       _inputController.text = _commandHistory[_historyIndex];
//                       _inputController.selection = TextSelection.fromPosition(TextPosition(offset: _inputController.text.length));
//                     });
//                     return KeyEventResult.handled;
//                   }
//                 } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
//                   if (_historyIndex > 0) {
//                     setState(() {
//                       _historyIndex--;
//                       _inputController.text = _commandHistory[_historyIndex];
//                     });
//                     return KeyEventResult.handled;
//                   } else if (_historyIndex == 0) {
//                     setState(() {
//                       _historyIndex = -1;
//                       _inputController.clear();
//                     });
//                     return KeyEventResult.handled;
//                   }
//                 }
//               }
//               return KeyEventResult.ignored;
//             },
//             child: TextField(
//               controller: _inputController,
//               focusNode: _focusNode,
//               autofocus: true,
//               cursorColor: const Color(0xFF6C63FF),
//               style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 14),
//               decoration: const InputDecoration(
//                 isDense: true,
//                 contentPadding: EdgeInsets.zero,
//                 border: InputBorder.none,
//               ),
//               onSubmitted: _handleCommand,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _dot(Color color) {
//     return Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
//   }
// }
//
// class TerminalLineData {
//   final String command;
//   final String response;
//   TerminalLineData({required this.command, required this.response});
// }
