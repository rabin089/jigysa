class User {
  final int id;
  final String name;
  final String email;
  final String username;
  final String? profile;
  final DateTime createdAt;
  final String role;
  final List<Idea> ideas;
  final int joinedYear;
  final int ideasCount;
  final int collaboratorsCount;
  final String? profession;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    this.profile,
    required this.createdAt,
    required this.role,
    required this.ideas,
    required this.joinedYear,
    required this.ideasCount,
    required this.collaboratorsCount,
    this.profession
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      profile: json['profile'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      role: json['role'] as String,
      ideas:
          (json['ideas'] as List<dynamic>)
              .map((e) => Idea.fromJson(e as Map<String, dynamic>))
              .toList(),
      joinedYear: json['joinedYear'] as int,
      ideasCount: json['ideasCount'] as int,
      collaboratorsCount: json['collaboratorsCount'] as int,
      profession: json['profession'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'username': username,
      'profile': profile,
      'createdAt': createdAt.toIso8601String(),
      'role': role,
      'ideas': ideas.map((e) => e.toJson()).toList(),
      'joinedYear': joinedYear,
      'ideasCount': ideasCount,
      'collaboratorsCount': collaboratorsCount,
      'profession': profession,
    };
  }
}

class Idea {
  final int id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;

  Idea({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Idea.fromJson(Map<String, dynamic> json) {
    return Idea(
      id: json['id'] as int,
      title: json['title'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
