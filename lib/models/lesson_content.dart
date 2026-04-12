import 'quiz_question.dart';

enum LessonType { video, text }

class LessonSection {
  const LessonSection({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;
}

class LessonContent {
  const LessonContent({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.accentColor,
    required this.contentTitle,
    required this.contentBody,
    required this.sections,
    required this.questions,
    this.videoAsset,
  });

  final String id;
  final String title;
  final String subtitle;
  final LessonType type;
  final int accentColor;
  final String contentTitle;
  final String contentBody;
  final List<LessonSection> sections;
  final List<QuizQuestion> questions;
  final String? videoAsset;
}
