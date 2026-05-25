class SignupRequest {
  final String fullName;
  final String username;
  final String email;
  final String password;
  final String profession;

  SignupRequest({
    required this.fullName,
    required this.username,
    required this.email,
    required this.password,
    required this.profession,
  });

  Map<String, dynamic> toJson() => {
    'name': fullName,
    'username': username,
    'email': email,
    'password': password,
    'profession': profession,
  };
}
