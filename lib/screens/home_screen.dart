import 'package:flutter/material.dart';

import '../data/demo_content.dart';
import '../models/folder_submission.dart';
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
    final totalFolders = lessons.fold<int>(
      0,
      (sum, lesson) => sum + lesson.folders.length,
    );
    final submittedFolders = lessons.fold<int>(
      0,
      (sum, lesson) => sum + appState.submittedFolderCount(lesson.id),
    );

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Text('Welcome back, ${user.name}', style: theme.textTheme.bodyLarge),
          const SizedBox(height: 6),
          Text('Learning Folders', style: theme.textTheme.headlineLarge),
          const SizedBox(height: 10),
          Text(
            'Open a folder, complete one task per page, and send open answers to your teacher for scoring.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1F7AFC), Color(0xFF46C071)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Student progress',
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$submittedFolders / $totalFolders folders submitted',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${user.points} total points',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
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
    final accent = Color(lesson.accentColor);
    final submitted = appState.submittedFolderCount(lesson.id);
    final pendingReviews = lesson.folders
        .map((folder) => appState.submissionForFolder(lesson.id, folder.id))
        .where(
          (submission) =>
              submission != null &&
              submission.status == SubmissionStatus.pendingReview,
        )
        .length;

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
                  color: accent.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Icon(_resolveIcon(lesson.title), size: 36, color: accent),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1C1A1A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      lesson.subtitle,
                      style: const TextStyle(
                        color: Color(0xFF615D58),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      lesson.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF615D58),
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _Tag(
                          label: '${lesson.folders.length} folders',
                          color: accent,
                        ),
                        _Tag(
                          label: '$submitted submitted',
                          color: const Color(0xFF46C071),
                        ),
                        if (pendingReviews > 0)
                          _Tag(
                            label: '$pendingReviews pending review',
                            color: const Color(0xFFFF8C42),
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

  IconData _resolveIcon(String title) {
    switch (title) {
      case 'Listening':
        return Icons.headphones_rounded;
      case 'Writing':
        return Icons.edit_note_rounded;
      case 'Vocabulary':
        return Icons.translate_rounded;
      default:
        return Icons.menu_book_rounded;
    }
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
