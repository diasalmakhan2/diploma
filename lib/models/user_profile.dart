class UserProfile {
  const UserProfile({
    required this.name,
    required this.email,
    required this.password,
    required this.points,
    required this.completedLessons,
  });

  final String name;
  final String email;
  final String password;
  final int points;
  final List<String> completedLessons;

  UserProfile copyWith({
    String? name,
    String? email,
    String? password,
    int? points,
    List<String>? completedLessons,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      points: points ?? this.points,
      completedLessons: completedLessons ?? this.completedLessons,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'points': points,
      'completedLessons': completedLessons,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      password: map['password'] as String? ?? '',
      points: map['points'] as int? ?? 0,
      completedLessons:
          (map['completedLessons'] as List<dynamic>? ?? <dynamic>[])
              .map((item) => item.toString())
              .toList(),
    );
  }
}
