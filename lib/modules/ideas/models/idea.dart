class Idea {
  final String id;
  final String title;
  final String description;
  final String? authorName;
  final String? authorAvatarUrl;
  final String? tag;
  final String? imageUrl;
  final int likes;
  final int comments;
  final int shares;
  final DateTime? createdAt;

  Idea({
    required this.id,
    required this.title,
    required this.description,
    this.authorName,
    this.authorAvatarUrl,
    this.tag,
    this.imageUrl,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.createdAt,
  });

  factory Idea.fromJson(Map<String, dynamic> json) {
    return Idea(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      authorName: json['authorName']?.toString() ?? json['author']?['name']?.toString(),
      authorAvatarUrl: json['authorAvatarUrl']?.toString() ?? json['author']?['avatar']?.toString(),
      tag: json['tag']?.toString() ?? (json['tags'] is List && (json['tags'] as List).isNotEmpty ? (json['tags'] as List).first.toString() : null),
      imageUrl: json['imageUrl']?.toString() ?? json['cover']?.toString(),
      likes: int.tryParse((json['likes'] ?? 0).toString()) ?? 0,
      comments: int.tryParse((json['comments'] ?? 0).toString()) ?? 0,
      shares: int.tryParse((json['shares'] ?? 0).toString()) ?? 0,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
    );
  }
}
