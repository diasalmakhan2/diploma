import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_profile.dart';

class AppState extends ChangeNotifier {
  static const _usersKey = 'users';
  static const _currentUserKey = 'current_user_email';

  SharedPreferences? _prefs;
  final List<UserProfile> _users = <UserProfile>[];
  UserProfile? _currentUser;

  UserProfile? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    final rawUsers = _prefs!.getString(_usersKey);
    if (rawUsers != null && rawUsers.isNotEmpty) {
      final decoded = jsonDecode(rawUsers) as List<dynamic>;
      _users
        ..clear()
        ..addAll(decoded.map((item) => UserProfile.fromMap(item as Map<String, dynamic>)));
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
  }) async {
    if (_users.any((user) => user.email.toLowerCase() == email.toLowerCase())) {
      return 'Пользователь с таким email уже существует.';
    }

    final profile = UserProfile(
      name: name.trim(),
      email: email.trim(),
      password: password,
      points: 0,
      completedLessons: <String>[],
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
      return 'Неверный email или пароль.';
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    await _prefs?.remove(_currentUserKey);
    notifyListeners();
  }

  bool isLessonCompleted(String lessonId) {
    return _currentUser?.completedLessons.contains(lessonId) ?? false;
  }

  Future<void> saveQuizResult({
    required String lessonId,
    required int earnedPoints,
  }) async {
    if (_currentUser == null) {
      return;
    }

    final alreadyCompleted = _currentUser!.completedLessons.contains(lessonId);
    final updatedLessons = <String>[
      ..._currentUser!.completedLessons,
      if (!alreadyCompleted) lessonId,
    ];

    final updatedUser = _currentUser!.copyWith(
      points: _currentUser!.points + (alreadyCompleted ? 0 : earnedPoints),
      completedLessons: updatedLessons,
    );

    _replaceUser(updatedUser);
    _currentUser = updatedUser;
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
    await _prefs?.setString(_usersKey, usersPayload);
    if (_currentUser != null) {
      await _prefs?.setString(_currentUserKey, _currentUser!.email);
    }
  }
}
