import 'package:flutter/material.dart';

import '../data/demo_content.dart';
import '../models/lesson_content.dart';
import '../widgets/app_scope.dart';
import 'lesson_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final user = appState.currentUser!;
    final theme = Theme.of(context);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Text('Hello, ${user.name}', style: theme.textTheme.bodyLarge),
          const SizedBox(height: 6),
          Text('Lesson Folders', style: theme.textTheme.headlineLarge),
          const SizedBox(height: 10),
          Text(
            'The main page now contains Listening, Writing, and Reading based on your prepared tasks.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1F7AFC),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.stars_rounded, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your progress',
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${user.points} points',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...lessons.map((lesson) => _LessonCard(lesson: lesson)),
        ],
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  const _LessonCard({required this.lesson});

  final LessonContent lesson;

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final isCompleted = appState.isLessonCompleted(lesson.id);
    final accent = Color(lesson.accentColor);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => LessonScreen(lesson: lesson)),
          );
        },
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Icon(
                  _resolveIcon(lesson),
                  size: 36,
                  color: accent,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1C1A1A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      lesson.subtitle,
                      style: const TextStyle(
                        color: Color(0xFF615D58),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _Tag(label: '${lesson.questions.length} questions', color: accent),
                        _Tag(
                          label: '${lesson.sections.length} sections',
                          color: const Color(0xFF615D58),
                        ),
                        _Tag(
                          label: isCompleted ? 'Completed' : 'Ready to open',
                          color: isCompleted
                              ? const Color(0xFF46C071)
                              : const Color(0xFF1F7AFC),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _resolveIcon(LessonContent lesson) {
    if (lesson.title == 'Listening') {
      return Icons.headphones_rounded;
    }
    if (lesson.title == 'Writing') {
      return Icons.edit_note_rounded;
    }
    return Icons.menu_book_rounded;
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
