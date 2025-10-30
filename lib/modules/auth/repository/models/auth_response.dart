class AuthUser {
  final String id;
  final String email;
  final String? name;
  final String? username;

  AuthUser({required this.id, required this.email, this.name, this.username});

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
    id: (json['id'] ?? json['_id'] ?? '').toString(),
    email: json['email']?.toString() ?? '',
    name: json['name']?.toString(),
    username: json['username']?.toString(),
  );
}

class AuthResponse {
  final String accessToken;
  final AuthUser? user;

  AuthResponse({required this.accessToken, this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    // Support multiple common API shapes
    // Support multiple token key names (camelCase and snake_case)
    final token =
        json['accessToken'] ??
        json['access_token'] ??
        json['token'] ??
        json['jwt'];
    final userJson =
        (json['user'] is Map<String, dynamic>) ? json['user'] : null;
    return AuthResponse(
      accessToken: token?.toString() ?? '',
      user:
          userJson == null
              ? null
              : AuthUser.fromJson(userJson as Map<String, dynamic>),
    );
  }
}
