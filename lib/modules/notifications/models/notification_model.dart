class NotificationModel {
  final String id;
  final String? type;
  final String? title;
  final String? body;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime? readAt;
  final DateTime? seenAt;

  NotificationModel({
    required this.id,
    this.type,
    this.title,
    this.body,
    this.metadata,
    required this.createdAt,
    this.readAt,
    this.seenAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      type: json['type']?.toString(),
      title: json['title']?.toString(),
      body: json['body']?.toString(),
      metadata: (json['metadata'] is Map<String, dynamic>)
          ? json['metadata'] as Map<String, dynamic>
          : null,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      readAt: json['readAt'] != null
          ? DateTime.tryParse(json['readAt'].toString())
          : null,
      seenAt: json['seenAt'] != null
          ? DateTime.tryParse(json['seenAt'].toString())
          : null,
    );
  }
}
