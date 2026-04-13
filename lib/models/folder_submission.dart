enum SubmissionStatus { pendingReview, resolved }

class SubmittedAnswer {
  const SubmittedAnswer({
    required this.stepId,
    required this.stepTitle,
    required this.prompt,
    required this.answerText,
    required this.autoEarnedPoints,
    required this.autoMaxPoints,
    required this.teacherAwardedPoints,
    required this.teacherMaxPoints,
    required this.requiresTeacherReview,
    this.sampleAnswer,
  });

  final String stepId;
  final String stepTitle;
  final String prompt;
  final String answerText;
  final int autoEarnedPoints;
  final int autoMaxPoints;
  final int teacherAwardedPoints;
  final int teacherMaxPoints;
  final bool requiresTeacherReview;
  final String? sampleAnswer;

  SubmittedAnswer copyWith({
    String? stepId,
    String? stepTitle,
    String? prompt,
    String? answerText,
    int? autoEarnedPoints,
    int? autoMaxPoints,
    int? teacherAwardedPoints,
    int? teacherMaxPoints,
    bool? requiresTeacherReview,
    String? sampleAnswer,
  }) {
    return SubmittedAnswer(
      stepId: stepId ?? this.stepId,
      stepTitle: stepTitle ?? this.stepTitle,
      prompt: prompt ?? this.prompt,
      answerText: answerText ?? this.answerText,
      autoEarnedPoints: autoEarnedPoints ?? this.autoEarnedPoints,
      autoMaxPoints: autoMaxPoints ?? this.autoMaxPoints,
      teacherAwardedPoints: teacherAwardedPoints ?? this.teacherAwardedPoints,
      teacherMaxPoints: teacherMaxPoints ?? this.teacherMaxPoints,
      requiresTeacherReview: requiresTeacherReview ?? this.requiresTeacherReview,
      sampleAnswer: sampleAnswer ?? this.sampleAnswer,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'stepId': stepId,
      'stepTitle': stepTitle,
      'prompt': prompt,
      'answerText': answerText,
      'autoEarnedPoints': autoEarnedPoints,
      'autoMaxPoints': autoMaxPoints,
      'teacherAwardedPoints': teacherAwardedPoints,
      'teacherMaxPoints': teacherMaxPoints,
      'requiresTeacherReview': requiresTeacherReview,
      'sampleAnswer': sampleAnswer,
    };
  }

  factory SubmittedAnswer.fromMap(Map<String, dynamic> map) {
    return SubmittedAnswer(
      stepId: map['stepId'] as String? ?? '',
      stepTitle: map['stepTitle'] as String? ?? '',
      prompt: map['prompt'] as String? ?? '',
      answerText: map['answerText'] as String? ?? '',
      autoEarnedPoints: map['autoEarnedPoints'] as int? ?? 0,
      autoMaxPoints: map['autoMaxPoints'] as int? ?? 0,
      teacherAwardedPoints: map['teacherAwardedPoints'] as int? ?? 0,
      teacherMaxPoints: map['teacherMaxPoints'] as int? ?? 0,
      requiresTeacherReview: map['requiresTeacherReview'] as bool? ?? false,
      sampleAnswer: map['sampleAnswer'] as String?,
    );
  }
}

class FolderSubmission {
  const FolderSubmission({
    required this.id,
    required this.lessonId,
    required this.lessonTitle,
    required this.folderId,
    required this.folderTitle,
    required this.studentEmail,
    required this.studentName,
    required this.submittedAt,
    required this.status,
    required this.objectivePoints,
    required this.objectiveMaxPoints,
    required this.teacherAwardedPoints,
    required this.teacherMaxPoints,
    required this.answers,
    this.reviewedAt,
    this.reviewedBy,
  });

  final String id;
  final String lessonId;
  final String lessonTitle;
  final String folderId;
  final String folderTitle;
  final String studentEmail;
  final String studentName;
  final String submittedAt;
  final SubmissionStatus status;
  final int objectivePoints;
  final int objectiveMaxPoints;
  final int teacherAwardedPoints;
  final int teacherMaxPoints;
  final List<SubmittedAnswer> answers;
  final String? reviewedAt;
  final String? reviewedBy;

  int get totalPoints => objectivePoints + teacherAwardedPoints;

  FolderSubmission copyWith({
    String? id,
    String? lessonId,
    String? lessonTitle,
    String? folderId,
    String? folderTitle,
    String? studentEmail,
    String? studentName,
    String? submittedAt,
    SubmissionStatus? status,
    int? objectivePoints,
    int? objectiveMaxPoints,
    int? teacherAwardedPoints,
    int? teacherMaxPoints,
    List<SubmittedAnswer>? answers,
    String? reviewedAt,
    String? reviewedBy,
  }) {
    return FolderSubmission(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      lessonTitle: lessonTitle ?? this.lessonTitle,
      folderId: folderId ?? this.folderId,
      folderTitle: folderTitle ?? this.folderTitle,
      studentEmail: studentEmail ?? this.studentEmail,
      studentName: studentName ?? this.studentName,
      submittedAt: submittedAt ?? this.submittedAt,
      status: status ?? this.status,
      objectivePoints: objectivePoints ?? this.objectivePoints,
      objectiveMaxPoints: objectiveMaxPoints ?? this.objectiveMaxPoints,
      teacherAwardedPoints: teacherAwardedPoints ?? this.teacherAwardedPoints,
      teacherMaxPoints: teacherMaxPoints ?? this.teacherMaxPoints,
      answers: answers ?? this.answers,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      reviewedBy: reviewedBy ?? this.reviewedBy,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lessonId': lessonId,
      'lessonTitle': lessonTitle,
      'folderId': folderId,
      'folderTitle': folderTitle,
      'studentEmail': studentEmail,
      'studentName': studentName,
      'submittedAt': submittedAt,
      'status': status.name,
      'objectivePoints': objectivePoints,
      'objectiveMaxPoints': objectiveMaxPoints,
      'teacherAwardedPoints': teacherAwardedPoints,
      'teacherMaxPoints': teacherMaxPoints,
      'answers': answers.map((answer) => answer.toMap()).toList(),
      'reviewedAt': reviewedAt,
      'reviewedBy': reviewedBy,
    };
  }

  factory FolderSubmission.fromMap(Map<String, dynamic> map) {
    return FolderSubmission(
      id: map['id'] as String? ?? '',
      lessonId: map['lessonId'] as String? ?? '',
      lessonTitle: map['lessonTitle'] as String? ?? '',
      folderId: map['folderId'] as String? ?? '',
      folderTitle: map['folderTitle'] as String? ?? '',
      studentEmail: map['studentEmail'] as String? ?? '',
      studentName: map['studentName'] as String? ?? '',
      submittedAt: map['submittedAt'] as String? ?? '',
      status: SubmissionStatus.values.firstWhere(
        (status) => status.name == (map['status'] as String? ?? ''),
        orElse: () => SubmissionStatus.pendingReview,
      ),
      objectivePoints: map['objectivePoints'] as int? ?? 0,
      objectiveMaxPoints: map['objectiveMaxPoints'] as int? ?? 0,
      teacherAwardedPoints: map['teacherAwardedPoints'] as int? ?? 0,
      teacherMaxPoints: map['teacherMaxPoints'] as int? ?? 0,
      answers:
          (map['answers'] as List<dynamic>? ?? <dynamic>[])
              .map(
                (item) => SubmittedAnswer.fromMap(
                  item as Map<String, dynamic>,
                ),
              )
              .toList(),
      reviewedAt: map['reviewedAt'] as String?,
      reviewedBy: map['reviewedBy'] as String?,
    );
  }
}
