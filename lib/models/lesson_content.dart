import 'quiz_question.dart';

enum LessonType { video, text }

class LessonContent {
  const LessonContent({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.accentColor,
    required this.contentTitle,
    required this.contentBody,
    required this.questions,
  });

  final String id;
  final String title;
  final String subtitle;
  final LessonType type;
  final int accentColor;
  final String contentTitle;
  final String contentBody;
  final List<QuizQuestion> questions;
}
