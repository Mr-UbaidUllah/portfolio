import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({super.key});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> with SingleTickerProviderStateMixin {
  bool _isSending = false;
  bool _isSuccess = false;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _subjectFocus = FocusNode();
  final _messageFocus = FocusNode();
  final _submitFocus = FocusNode();

  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _subjectFocus.dispose();
    _messageFocus.dispose();
    _submitFocus.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSending = true);
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() {
          _isSending = false;
          _isSuccess = true;
        });
        SemanticsService.sendAnnouncement(View.of(context), 'Message sent successfully!', TextDirection.ltr);
        // Reset after success
        await Future.delayed(const Duration(seconds: 4));
        if (mounted) {
          setState(() {
            _isSuccess = false;
            _nameController.clear();
            _emailController.clear();
            _subjectController.clear();
            _messageController.clear();
          });
        }
      }
    } else {
      _shakeController.forward(from: 0.0);
      HapticFeedback.vibrate();
      SemanticsService.sendAnnouncement(View.of(context), 'Form has validation errors. Please correct them.', TextDirection.ltr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: animation, child: child),
        );
      },
      child: _isSuccess ? _buildSuccessState() : _buildFormState(),
    );
  }

  Widget _buildFormState() {
    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        final double offset = (const SineCurve().transform(_shakeController.value) * 10);
        return Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        );
      },
      child: Semantics(
        label: 'Contact form',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Send a Message',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'I\'ll get back to you as soon as possible.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildModernTextField(
                      label: 'Full Name',
                      hint: 'John Doe',
                      icon: Icons.person_outline_rounded,
                      controller: _nameController,
                      focusNode: _nameFocus,
                      nextFocus: _emailFocus,
                      validator: (v) => v == null || v.isEmpty ? 'Name is required' : null,
                    ),
                    const SizedBox(height: 24),
                    _buildModernTextField(
                      label: 'Email Address',
                      hint: 'john@example.com',
                      icon: Icons.alternate_email_rounded,
                      controller: _emailController,
                      focusNode: _emailFocus,
                      nextFocus: _subjectFocus,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Email is required';
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildModernTextField(
                      label: 'Subject',
                      hint: 'Project Inquiry',
                      icon: Icons.subject_rounded,
                      controller: _subjectController,
                      focusNode: _subjectFocus,
                      nextFocus: _messageFocus,
                    ),
                    const SizedBox(height: 24),
                    _buildModernTextField(
                      label: 'Message',
                      hint: 'How can I help you?',
                      maxLines: 4,
                      controller: _messageController,
                      focusNode: _messageFocus,
                      nextFocus: _submitFocus,
                      validator: (v) => v == null || v.isEmpty ? 'Message is required' : null,
                    ),
                    const SizedBox(height: 40),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessState() {
    return Container(
      key: const ValueKey('success'),
      height: 600,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Using flutter_animate to create a Lottie-like success feel without adding dependency
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF00FF94).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF00FF94),
              size: 64,
            ),
          )
          .animate()
          .scale(duration: 600.ms, curve: Curves.easeOutBack)
          .then()
          .shake(duration: 400.ms),
          
          const SizedBox(height: 24),
          const Text(
            'Message Sent!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
          const SizedBox(height: 12),
          Text(
            'Thank you for reaching out. I\'ll be in touch soon.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
        ],
      ),
    );
  }

  Widget _buildModernTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocus,
    IconData? icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return FormField<String>(
      validator: validator,
      initialValue: controller.text,
      builder: (state) {
        final bool hasError = state.hasError;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Row(
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: hasError ? Colors.redAccent : Colors.white.withValues(alpha: 0.7),
                      letterSpacing: 0.5,
                    ),
                  ),
                  if (hasError)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: const Icon(Icons.error_outline, size: 14, color: Colors.redAccent)
                          .animate()
                          .fadeIn()
                          .shake(),
                    ),
                ],
              ),
            ),
            TextFormField(
              controller: controller,
              focusNode: focusNode,
              maxLines: maxLines,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              onChanged: (value) {
                state.didChange(value);
              },
              textInputAction: nextFocus != null ? TextInputAction.next : TextInputAction.done,
              onFieldSubmitted: (_) {
                if (nextFocus != null) {
                  FocusScope.of(context).requestFocus(nextFocus);
                } else {
                  _handleSubmit();
                }
              },
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
                prefixIcon: icon != null
                    ? Icon(icon, color: hasError ? Colors.redAccent.withValues(alpha: 0.7) : Colors.white.withValues(alpha: 0.3), size: 20)
                    : null,
                suffixIcon: hasError 
                  ? const Icon(Icons.info_outline, color: Colors.redAccent, size: 20)
                  : null,
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.02),
                contentPadding: const EdgeInsets.all(20),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: hasError ? Colors.redAccent.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.08),
                    width: hasError ? 2 : 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: hasError ? Colors.redAccent : const Color(0xFF6C63FF),
                    width: 2,
                  ),
                ),
                errorStyle: const TextStyle(height: 0, fontSize: 0), // Hide default error text
              ),
            ),
            if (hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 4),
                child: Text(
                  state.errorText ?? '',
                  style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                ).animate().fadeIn().slideX(begin: -0.1),
              ),
          ],
        );
      },
    );
  }

  Widget _buildSubmitButton() {
    bool isHovered = false;
    return StatefulBuilder(
      builder: (context, setBtnState) {
        return Focus(
          focusNode: _submitFocus,
          onFocusChange: (focused) => setBtnState(() => isHovered = focused),
          child: MouseRegion(
            onEnter: (_) => setBtnState(() => isHovered = true),
            onExit: (_) => setBtnState(() => isHovered = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: isHovered 
                    ? [const Color(0xFF7C73FF), const Color(0xFF5B55DC)]
                    : [const Color(0xFF6C63FF), const Color(0xFF4B45CC)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withValues(alpha: isHovered ? 0.5 : 0.3),
                    blurRadius: isHovered ? 30 : 20,
                    offset: Offset(0, isHovered ? 12 : 10),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isSending ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: isHovered ? const BorderSide(color: Colors.white, width: 1.5) : BorderSide.none,
                  ),
                ),
                child: _isSending
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Send Message',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(width: 12),
                          Icon(Icons.arrow_forward_rounded, size: 20),
                        ],
                      ),
              ),
            ),
          ),
        );
      }
    );
  }
}

class SineCurve extends Curve {
  const SineCurve({this.count = 3});
  final double count;
  @override
  double transformInternal(double t) {
    return math.sin(t * count * 2 * math.pi);
  }
}
