import 'package:flutter/material.dart';

import '../models/folder_submission.dart';
import '../models/lesson_content.dart';
import '../widgets/app_scope.dart';
import 'folder_task_screen.dart';

class LessonScreen extends StatelessWidget {
  const LessonScreen({super.key, required this.lesson});

  final LessonContent lesson;

  @override
  Widget build(BuildContext context) {
    final accent = Color(lesson.accentColor);
    final appState = AppScope.of(context);
    final submittedCount = appState.submittedFolderCount(lesson.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accent, accent.withOpacity(0.74)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  lesson.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  lesson.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  '$submittedCount of ${lesson.folders.length} folders submitted',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...lesson.folders.map(
            (folder) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _FolderCard(lesson: lesson, folder: folder),
            ),
          ),
        ],
      ),
    );
  }
}

class _FolderCard extends StatelessWidget {
  const _FolderCard({
    required this.lesson,
    required this.folder,
  });

  final LessonContent lesson;
  final LessonFolder folder;

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final submission = appState.submissionForFolder(lesson.id, folder.id);
    final accent = Color(lesson.accentColor);
    final statusLabel = _statusLabel(submission);
    final statusColor = _statusColor(submission);

    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => FolderTaskScreen(
              lesson: lesson,
              folder: folder,
            ),
          ),
        );
      },
      child: Ink(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: accent.withOpacity(0.16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    folder.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                _StatusChip(label: statusLabel, color: statusColor),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              folder.subtitle,
              style: TextStyle(
                color: accent,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              folder.description,
              style: const TextStyle(
                color: Color(0xFF615D58),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _StatusChip(
                  label: '${folder.steps.length} pages',
                  color: const Color(0xFF615D58),
                ),
                _StatusChip(
                  label: '${folder.objectiveMaxPoints} auto points',
                  color: const Color(0xFF1F7AFC),
                ),
                if (folder.teacherMaxPoints > 0)
                  _StatusChip(
                    label: '${folder.teacherMaxPoints} teacher points',
                    color: const Color(0xFFFF8C42),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(FolderSubmission? submission) {
    if (submission == null) {
      return 'Ready';
    }
    if (submission.status == SubmissionStatus.pendingReview) {
      return 'Pending Review';
    }
    return 'Resolved';
  }

  Color _statusColor(FolderSubmission? submission) {
    if (submission == null) {
      return const Color(0xFF1F7AFC);
    }
    if (submission.status == SubmissionStatus.pendingReview) {
      return const Color(0xFFFF8C42);
    }
    return const Color(0xFF46C071);
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.color,
  });

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
