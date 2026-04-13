import 'package:flutter/material.dart';

import '../models/folder_submission.dart';
import '../widgets/app_scope.dart';
import 'teacher_review_screen.dart';

class TeacherDashboardScreen extends StatelessWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final submissions = [...appState.submissions]
      ..sort((a, b) {
        if (a.status != b.status) {
          return a.status == SubmissionStatus.pendingReview ? -1 : 1;
        }
        return b.submittedAt.compareTo(a.submittedAt);
      });
    final pending = submissions
        .where((item) => item.status == SubmissionStatus.pendingReview)
        .length;
    final resolved = submissions
        .where((item) => item.status == SubmissionStatus.resolved)
        .length;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          const Text(
            'Teacher Review',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Review student submissions, score open answers, and mark work as resolved.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF615D58),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Pending',
                  value: '$pending',
                  color: const Color(0xFFFF8C42),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'Resolved',
                  value: '$resolved',
                  color: const Color(0xFF46C071),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (submissions.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Text(
                'No student submissions yet.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            )
          else
            ...submissions.map(
              (submission) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(28),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TeacherReviewScreen(
                          submissionId: submission.id,
                        ),
                      ),
                    );
                  },
                  child: Ink(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                submission.folderTitle,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            _StatusTag(status: submission.status),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${submission.studentName} - ${submission.lessonTitle}',
                          style: const TextStyle(
                            color: Color(0xFF615D58),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _MiniTag(
                              label:
                                  'Auto ${submission.objectivePoints}/${submission.objectiveMaxPoints}',
                              color: const Color(0xFF1F7AFC),
                            ),
                            _MiniTag(
                              label:
                                  'Teacher ${submission.teacherAwardedPoints}/${submission.teacherMaxPoints}',
                              color: const Color(0xFFFF8C42),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusTag extends StatelessWidget {
  const _StatusTag({required this.status});

  final SubmissionStatus status;

  @override
  Widget build(BuildContext context) {
    final isPending = status == SubmissionStatus.pendingReview;
    final color = isPending ? const Color(0xFFFF8C42) : const Color(0xFF46C071);
    return _MiniTag(
      label: isPending ? 'Pending' : 'Resolved',
      color: color,
    );
  }
}

class _MiniTag extends StatelessWidget {
  const _MiniTag({
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
