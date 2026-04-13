enum UserRole { student, teacher }

extension UserRoleLabel on UserRole {
  String get label => this == UserRole.teacher ? 'Teacher' : 'Student';
}

class UserProfile {
  const UserProfile({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.points,
    required this.submittedFolders,
  });

  final String name;
  final String email;
  final String password;
  final UserRole role;
  final int points;
  final List<String> submittedFolders;

  UserProfile copyWith({
    String? name,
    String? email,
    String? password,
    UserRole? role,
    int? points,
    List<String>? submittedFolders,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      points: points ?? this.points,
      submittedFolders: submittedFolders ?? this.submittedFolders,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'role': role.name,
      'points': points,
      'submittedFolders': submittedFolders,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      password: map['password'] as String? ?? '',
      role: UserRole.values.firstWhere(
        (role) => role.name == (map['role'] as String? ?? ''),
        orElse: () => UserRole.student,
      ),
      points: map['points'] as int? ?? 0,
      submittedFolders:
          (map['submittedFolders'] as List<dynamic>? ??
                  map['completedLessons'] as List<dynamic>? ??
                  <dynamic>[])
              .map((item) => item.toString())
              .toList(),
    );
  }
}
