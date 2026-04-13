enum LessonStepType {
  info,
  multipleChoice,
  fillBlank,
  openText,
  longText,
  checklist,
}

enum LessonMediaType { image, audio }

class LessonMedia {
  const LessonMedia({
    required this.type,
    required this.title,
    required this.description,
    required this.emptyStateText,
    this.assetPath,
  });

  final LessonMediaType type;
  final String title;
  final String description;
  final String emptyStateText;
  final String? assetPath;
}

class LessonStep {
  const LessonStep({
    required this.id,
    required this.title,
    required this.prompt,
    required this.type,
    this.instructions,
    this.content = const <String>[],
    this.options = const <String>[],
    this.correctOptionIndex,
    this.acceptedAnswers = const <String>[],
    this.checklistItems = const <String>[],
    this.helperLines = const <String>[],
    this.wordBank = const <String>[],
    this.autoPoints = 0,
    this.teacherMaxPoints = 0,
    this.sampleAnswer,
    this.placeholder,
  });

  final String id;
  final String title;
  final String prompt;
  final LessonStepType type;
  final String? instructions;
  final List<String> content;
  final List<String> options;
  final int? correctOptionIndex;
  final List<String> acceptedAnswers;
  final List<String> checklistItems;
  final List<String> helperLines;
  final List<String> wordBank;
  final int autoPoints;
  final int teacherMaxPoints;
  final String? sampleAnswer;
  final String? placeholder;

  bool get requiresTeacherReview => teacherMaxPoints > 0;
}

class LessonFolder {
  const LessonFolder({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.steps,
    this.media,
  });

  final String id;
  final String title;
  final String subtitle;
  final String description;
  final List<LessonStep> steps;
  final LessonMedia? media;

  int get objectiveMaxPoints =>
      steps.fold<int>(0, (sum, step) => sum + step.autoPoints);

  int get teacherMaxPoints =>
      steps.fold<int>(0, (sum, step) => sum + step.teacherMaxPoints);
}

class LessonContent {
  const LessonContent({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.accentColor,
    required this.folders,
  });

  final String id;
  final String title;
  final String subtitle;
  final String description;
  final int accentColor;
  final List<LessonFolder> folders;
}
