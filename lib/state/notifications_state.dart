import 'package:equatable/equatable.dart';
import '../modules/notifications/models/notification_model.dart';

enum NotificationsStatus { initial, connecting, connected, error }

class NotificationsState extends Equatable {
  final List<NotificationModel> items;
  final int unread;
  final NotificationsStatus status;
  final String? error;

  const NotificationsState({
    this.items = const [],
    this.unread = 0,
    this.status = NotificationsStatus.initial,
    this.error,
  });

  NotificationsState copyWith({
    List<NotificationModel>? items,
    int? unread,
    NotificationsStatus? status,
    String? error,
  }) {
    return NotificationsState(
      items: items ?? this.items,
      unread: unread ?? this.unread,
      status: status ?? this.status,
      error: error,
    );
  }

  @override
  List<Object?> get props => [items, unread, status, error];
}
