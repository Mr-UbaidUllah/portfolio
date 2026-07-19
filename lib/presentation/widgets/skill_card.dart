import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SkillCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<SkillProgress> skills;
  final String description;
  final Color accentColor;

  const SkillCard({
    super.key,
    required this.title,
    required this.icon,
    required this.skills,
    this.description = '',
    this.accentColor = const Color(0xFF6C63FF),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.03),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF0D0D1E).withValues(alpha: 0.6),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.04),
                  Colors.white.withValues(alpha: 0.01),
                ],
              ),
            ),
            child: Semantics(
              container: true,
              label: 'Skill category: $title',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: accentColor.withValues(alpha: 0.2)),
                        ),
                        child: Icon(icon, color: accentColor, size: 32),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${skills.length} Technologies',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.4),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.5),
                        height: 1.6,
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  _buildSkillsList(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkillsList(BuildContext context) {
    final bool reduceMotion = MediaQuery.of(context).accessibleNavigation || 
                             MediaQuery.of(context).disableAnimations;
    
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: skills.asMap().entries.map((entry) {
        final chip = TechChip(
          skill: entry.value,
          accentColor: accentColor,
        );
        if (reduceMotion) return chip;
        return chip.animate().fadeIn(delay: (entry.key * 100).ms).scale(
          delay: (entry.key * 100).ms,
          begin: const Offset(0.8, 0.8),
        );
      }).toList(),
    );
  }
}

class TechChip extends StatefulWidget {
  final SkillProgress skill;
  final Color accentColor;

  const TechChip({super.key, required this.skill, required this.accentColor});

  @override
  State<TechChip> createState() => _TechChipState();
}

class _TechChipState extends State<TechChip> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool reduceMotion = MediaQuery.of(context).accessibleNavigation || 
                             MediaQuery.of(context).disableAnimations;

    return Focus(
      onFocusChange: (focused) => setState(() => isHovered = focused),
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: Semantics(
          button: true,
          label: '${widget.skill.name}, proficiency ${(widget.skill.percentage * 100).toInt()}%',
          child: GestureDetector(
            onTap: () => _showSkillDetails(context),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isHovered
                    ? widget.accentColor.withValues(alpha: 0.15)
                    : Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isHovered
                      ? widget.accentColor.withValues(alpha: 0.5)
                      : Colors.white.withValues(alpha: 0.08),
                  width: isHovered ? 1.5 : 1.0,
                ),
                boxShadow: isHovered && !reduceMotion
                    ? [
                        BoxShadow(
                          color: widget.accentColor.withValues(alpha: 0.2),
                          blurRadius: 15,
                          spreadRadius: -2,
                        )
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLogo(),
                  const SizedBox(width: 10),
                  Text(
                    widget.skill.name,
                    style: TextStyle(
                      color:
                          isHovered ? Colors.white : Colors.white.withValues(alpha: 0.8),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 10),
                  _ProficiencyIndicator(
                    percentage: widget.skill.percentage,
                    color: widget.accentColor,
                    isHovered: isHovered,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          widget.skill.name[0],
          style: TextStyle(
            color: isHovered ? widget.accentColor : Colors.white60,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showSkillDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: AlertDialog(
          backgroundColor: const Color(0xFF0D0D1E).withValues(alpha: 0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: widget.accentColor.withValues(alpha: 0.3)),
          ),
          title: Row(
            children: [
              _buildLogo(),
              const SizedBox(width: 16),
              Text(
                widget.skill.name,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Proficiency: ${(widget.skill.percentage * 100).toInt()}%',
                style: TextStyle(
                  color: widget.accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              const _DetailRow(label: 'Experience', value: '2+ Years'),
              const _DetailRow(
                label: 'Projects',
                value: 'Used in 5+ production apps',
              ),
              const SizedBox(height: 16),
              Text(
                'Highly proficient in ${widget.skill.name}, utilizing it to build robust, scalable, and maintainable solutions with a focus on modern architecture.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  height: 1.5,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: TextStyle(color: widget.accentColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProficiencyIndicator extends StatelessWidget {
  final double percentage;
  final Color color;
  final bool isHovered;

  const _ProficiencyIndicator({
    required this.percentage,
    required this.color,
    required this.isHovered,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            value: percentage,
            strokeWidth: 2.2,
            backgroundColor: Colors.white.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        if (isHovered)
          Text(
            '${(percentage * 100).toInt()}',
            style: const TextStyle(
              fontSize: 7,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }
}

class SkillProgress {
  final String name;
  final double percentage;

  SkillProgress({required this.name, required this.percentage});
}
