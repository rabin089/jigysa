import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jigyasa/services/notifications/notifications_ws.service.dart';
import '../modules/notifications/models/notification_model.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsWsService _ws;
  final List<NotificationModel> _items = [];
  StreamSubscription? _newSub;
  StreamSubscription? _updatedSub;

  NotificationsCubit({NotificationsWsService? ws})
      : _ws = ws ?? NotificationsWsService(),
        super(const NotificationsState(status: NotificationsStatus.initial));

  Future<void> init() async {
    if (state.status == NotificationsStatus.connected ||
        state.status == NotificationsStatus.connecting) {
      return;
    }
    emit(state.copyWith(status: NotificationsStatus.connecting));

    await _ws.connect();

    _newSub = _ws.onNew.listen((n) {
      _items.insert(0, n);
      _recalculate();
    });

    _updatedSub = _ws.onUpdated.listen((n) {
      final idx = _items.indexWhere((e) => e.id == n.id);
      if (idx != -1) {
        _items[idx] = n;
      } else {
        _items.insert(0, n);
      }
      _recalculate();
    });

    emit(state.copyWith(status: NotificationsStatus.connected));
  }

  void _recalculate() {
    final unread = _items.where((e) => e.readAt == null).length;
    emit(state.copyWith(items: List.unmodifiable(_items), unread: unread));
  }

  @override
  Future<void> close() {
    _newSub?.cancel();
    _updatedSub?.cancel();
    _ws.dispose();
    return super.close();
  }
}
