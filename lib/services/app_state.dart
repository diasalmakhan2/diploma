import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/folder_submission.dart';
import '../models/lesson_content.dart';
import '../models/user_profile.dart';

class AppState extends ChangeNotifier {
  static const _usersKey = 'users';
  static const _currentUserKey = 'current_user_email';
  static const _submissionsKey = 'folder_submissions';

  SharedPreferences? _prefs;
  final List<UserProfile> _users = <UserProfile>[];
  final List<FolderSubmission> _submissions = <FolderSubmission>[];
  UserProfile? _currentUser;

  UserProfile? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isTeacher => _currentUser?.role == UserRole.teacher;

  List<FolderSubmission> get submissions => List<FolderSubmission>.unmodifiable(
    [..._submissions]..sort((a, b) => b.submittedAt.compareTo(a.submittedAt)),
  );

  int get pendingReviewCount =>
      _submissions.where((item) => item.status == SubmissionStatus.pendingReview).length;

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();

    final rawUsers = _prefs!.getString(_usersKey);
    if (rawUsers != null && rawUsers.isNotEmpty) {
      final decoded = jsonDecode(rawUsers) as List<dynamic>;
      _users
        ..clear()
        ..addAll(
          decoded.map(
            (item) => UserProfile.fromMap(item as Map<String, dynamic>),
          ),
        );
    }

    final rawSubmissions = _prefs!.getString(_submissionsKey);
    if (rawSubmissions != null && rawSubmissions.isNotEmpty) {
      final decoded = jsonDecode(rawSubmissions) as List<dynamic>;
      _submissions
        ..clear()
        ..addAll(
          decoded.map(
            (item) => FolderSubmission.fromMap(item as Map<String, dynamic>),
          ),
        );
    }

    final currentEmail = _prefs!.getString(_currentUserKey);
    if (currentEmail != null) {
      try {
        _currentUser = _users.firstWhere((user) => user.email == currentEmail);
      } catch (_) {
        _currentUser = null;
      }
    }

    notifyListeners();
  }

  Future<String?> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    if (_users.any((user) => user.email.toLowerCase() == email.toLowerCase())) {
      return 'An account with this email already exists.';
    }

    final profile = UserProfile(
      name: name.trim(),
      email: email.trim(),
      password: password,
      role: role,
      points: 0,
      submittedFolders: <String>[],
    );

    _users.add(profile);
    _currentUser = profile;
    await _persist();
    notifyListeners();
    return null;
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      _currentUser = _users.firstWhere(
        (user) =>
            user.email.toLowerCase() == email.trim().toLowerCase() &&
            user.password == password,
      );
      await _prefs?.setString(_currentUserKey, _currentUser!.email);
      notifyListeners();
      return null;
    } catch (_) {
      return 'Incorrect email or password.';
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    await _prefs?.remove(_currentUserKey);
    notifyListeners();
  }

  bool isFolderSubmitted(String lessonId, String folderId) {
    final key = _folderKey(lessonId, folderId);
    return _currentUser?.submittedFolders.contains(key) ?? false;
  }

  int submittedFolderCount(String lessonId) {
    if (_currentUser == null) {
      return 0;
    }
    return _currentUser!.submittedFolders
        .where((item) => item.startsWith('$lessonId::'))
        .length;
  }

  FolderSubmission? submissionForFolder(String lessonId, String folderId) {
    final email = _currentUser?.email;
    if (email == null) {
      return null;
    }
    for (final submission in _submissions) {
      if (submission.lessonId == lessonId &&
          submission.folderId == folderId &&
          submission.studentEmail == email) {
        return submission;
      }
    }
    return null;
  }

  Future<FolderSubmission?> submitFolder({
    required LessonContent lesson,
    required LessonFolder folder,
    required Map<String, Object?> answers,
  }) async {
    final user = _currentUser;
    if (user == null || user.role != UserRole.student) {
      return null;
    }

    final existing = submissionForFolder(lesson.id, folder.id);
    if (existing != null) {
      return existing;
    }

    final submittedAnswers = <SubmittedAnswer>[];
    var objectivePoints = 0;
    var objectiveMaxPoints = 0;
    var teacherMaxPoints = 0;

    for (final step in folder.steps) {
      if (step.type == LessonStepType.info) {
        continue;
      }

      var answerText = '';
      var autoEarnedPoints = 0;
      var autoMaxPoints = step.autoPoints;

      switch (step.type) {
        case LessonStepType.multipleChoice:
          final selectedIndex = answers[step.id] as int?;
          if (selectedIndex != null &&
              step.correctOptionIndex != null &&
              selectedIndex >= 0 &&
              selectedIndex < step.options.length) {
            answerText = step.options[selectedIndex];
            if (selectedIndex == step.correctOptionIndex) {
              autoEarnedPoints = step.autoPoints;
            }
          }
          break;
        case LessonStepType.fillBlank:
          final rawText = (answers[step.id] as String? ?? '').trim();
          answerText = rawText;
          if (_matchesAcceptedAnswer(rawText, step.acceptedAnswers)) {
            autoEarnedPoints = step.autoPoints;
          }
          break;
        case LessonStepType.openText:
        case LessonStepType.longText:
          answerText = (answers[step.id] as String? ?? '').trim();
          autoMaxPoints = 0;
          break;
        case LessonStepType.checklist:
          final checked =
              (answers[step.id] as List<String>? ?? <String>[]);
          answerText = checked.join('\n');
          autoMaxPoints = 0;
          break;
        case LessonStepType.info:
          break;
      }

      objectivePoints += autoEarnedPoints;
      objectiveMaxPoints += autoMaxPoints;
      teacherMaxPoints += step.teacherMaxPoints;

      submittedAnswers.add(
        SubmittedAnswer(
          stepId: step.id,
          stepTitle: step.title,
          prompt: step.prompt,
          answerText: answerText,
          autoEarnedPoints: autoEarnedPoints,
          autoMaxPoints: autoMaxPoints,
          teacherAwardedPoints: 0,
          teacherMaxPoints: step.teacherMaxPoints,
          requiresTeacherReview: step.requiresTeacherReview,
          sampleAnswer: step.sampleAnswer,
        ),
      );
    }

    final submission = FolderSubmission(
      id: '${user.email}_${lesson.id}_${folder.id}',
      lessonId: lesson.id,
      lessonTitle: lesson.title,
      folderId: folder.id,
      folderTitle: folder.title,
      studentEmail: user.email,
      studentName: user.name,
      submittedAt: DateTime.now().toIso8601String(),
      status: teacherMaxPoints > 0
          ? SubmissionStatus.pendingReview
          : SubmissionStatus.resolved,
      objectivePoints: objectivePoints,
      objectiveMaxPoints: objectiveMaxPoints,
      teacherAwardedPoints: 0,
      teacherMaxPoints: teacherMaxPoints,
      answers: submittedAnswers,
    );

    _submissions.add(submission);

    final updatedUser = user.copyWith(
      points: user.points + objectivePoints,
      submittedFolders: <String>[
        ...user.submittedFolders,
        _folderKey(lesson.id, folder.id),
      ],
    );
    _replaceUser(updatedUser);
    _currentUser = updatedUser;

    await _persist();
    notifyListeners();
    return submission;
  }

  Future<void> reviewSubmission({
    required String submissionId,
    required Map<String, int> teacherScores,
  }) async {
    if (!isTeacher) {
      return;
    }

    final index = _submissions.indexWhere((item) => item.id == submissionId);
    if (index < 0) {
      return;
    }

    final submission = _submissions[index];
    final rescoredAnswers = submission.answers.map((answer) {
      if (!answer.requiresTeacherReview) {
        return answer;
      }

      final requestedScore = teacherScores[answer.stepId] ?? answer.teacherAwardedPoints;
      final boundedScore = requestedScore.clamp(0, answer.teacherMaxPoints).toInt();
      return answer.copyWith(teacherAwardedPoints: boundedScore);
    }).toList();

    final newTeacherPoints = rescoredAnswers.fold<int>(
      0,
      (sum, answer) => sum + answer.teacherAwardedPoints,
    );
    final delta = newTeacherPoints - submission.teacherAwardedPoints;

    final reviewedSubmission = submission.copyWith(
      answers: rescoredAnswers,
      teacherAwardedPoints: newTeacherPoints,
      status: SubmissionStatus.resolved,
      reviewedAt: DateTime.now().toIso8601String(),
      reviewedBy: _currentUser?.name,
    );
    _submissions[index] = reviewedSubmission;

    final studentIndex = _users.indexWhere(
      (item) => item.email == submission.studentEmail,
    );
    if (studentIndex >= 0) {
      final student = _users[studentIndex];
      final updatedStudent = student.copyWith(points: student.points + delta);
      _users[studentIndex] = updatedStudent;
      if (_currentUser?.email == updatedStudent.email) {
        _currentUser = updatedStudent;
      }
    }

    await _persist();
    notifyListeners();
  }

  void _replaceUser(UserProfile updatedUser) {
    final index = _users.indexWhere((user) => user.email == updatedUser.email);
    if (index >= 0) {
      _users[index] = updatedUser;
    }
  }

  Future<void> _persist() async {
    final usersPayload = jsonEncode(_users.map((user) => user.toMap()).toList());
    final submissionsPayload = jsonEncode(
      _submissions.map((submission) => submission.toMap()).toList(),
    );
    await _prefs?.setString(_usersKey, usersPayload);
    await _prefs?.setString(_submissionsKey, submissionsPayload);
    if (_currentUser != null) {
      await _prefs?.setString(_currentUserKey, _currentUser!.email);
    }
  }

  String _folderKey(String lessonId, String folderId) => '$lessonId::$folderId';

  bool _matchesAcceptedAnswer(String rawText, List<String> acceptedAnswers) {
    final normalized = _normalize(rawText);
    return acceptedAnswers.any((answer) => _normalize(answer) == normalized);
  }

  String _normalize(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), ' ');
  }
}
