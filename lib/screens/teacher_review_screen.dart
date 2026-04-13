import 'package:flutter/material.dart';

import '../models/folder_submission.dart';
import '../widgets/app_scope.dart';

class TeacherReviewScreen extends StatefulWidget {
  const TeacherReviewScreen({
    super.key,
    required this.submissionId,
  });

  final String submissionId;

  @override
  State<TeacherReviewScreen> createState() => _TeacherReviewScreenState();
}

class _TeacherReviewScreenState extends State<TeacherReviewScreen> {
  final Map<String, int> _scores = <String, int>{};
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    FolderSubmission? submission;
    for (final item in appState.submissions) {
      if (item.id == widget.submissionId) {
        submission = item;
        break;
      }
    }

    if (submission == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Submission not found.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
        ),
      );
    }

    for (final answer in submission.answers.where((item) => item.requiresTeacherReview)) {
      _scores.putIfAbsent(answer.stepId, () => answer.teacherAwardedPoints);
    }

    final reviewedPoints = _scores.values.fold<int>(0, (sum, item) => sum + item);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Submission'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  submission.folderTitle,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${submission.studentName} - ${submission.studentEmail}',
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
                    _Tag(
                      label:
                          'Auto ${submission.objectivePoints}/${submission.objectiveMaxPoints}',
                      color: const Color(0xFF1F7AFC),
                    ),
                    _Tag(
                      label: 'Teacher $reviewedPoints/${submission.teacherMaxPoints}',
                      color: const Color(0xFFFF8C42),
                    ),
                    _Tag(
                      label: submission.status == SubmissionStatus.pendingReview
                          ? 'Pending'
                          : 'Resolved',
                      color: submission.status == SubmissionStatus.pendingReview
                          ? const Color(0xFFFF8C42)
                          : const Color(0xFF46C071),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...submission.answers.map(
            (answer) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      answer.stepTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1C1A1A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      answer.prompt,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF3F3A35),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      answer.answerText.isEmpty ? 'No answer provided.' : answer.answerText,
                      style: const TextStyle(
                        color: Color(0xFF615D58),
                        height: 1.4,
                      ),
                    ),
                    if (answer.sampleAnswer != null &&
                        answer.sampleAnswer!.trim().isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Reference answer',
                        style: TextStyle(
                          color: const Color(0xFFFF8C42).withOpacity(0.9),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        answer.sampleAnswer!,
                        style: const TextStyle(
                          color: Color(0xFF615D58),
                          height: 1.4,
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    if (answer.requiresTeacherReview)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(answer.teacherMaxPoints + 1, (score) {
                          final selected = _scores[answer.stepId] == score;
                          return ChoiceChip(
                            label: Text('$score'),
                            selected: selected,
                            onSelected: (_) {
                              setState(() {
                                _scores[answer.stepId] = score;
                              });
                            },
                          );
                        }),
                      )
                    else
                      _Tag(
                        label: 'Auto ${answer.autoEarnedPoints}/${answer.autoMaxPoints}',
                        color: const Color(0xFF1F7AFC),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _saving
                ? null
                : () async {
                    setState(() {
                      _saving = true;
                    });
                    await appState.reviewSubmission(
                      submissionId: submission.id,
                      teacherScores: _scores,
                    );
                    if (!context.mounted) {
                      return;
                    }
                    setState(() {
                      _saving = false;
                    });
                    Navigator.of(context).pop();
                  },
            child: Text(_saving ? 'Saving...' : 'Save review and resolve'),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
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
