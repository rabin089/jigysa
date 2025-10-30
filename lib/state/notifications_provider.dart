import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:jigyasa/modules/notifications/models/notification_model.dart';
import 'package:jigyasa/services/notifications/notifications_ws.service.dart';

class NotificationsProvider extends ChangeNotifier {
  final NotificationsWsService _ws = NotificationsWsService();

  final List<NotificationModel> _items = [];
  int _unread = 0;
  bool _listening = false;

  UnmodifiableListView<NotificationModel> get items => UnmodifiableListView(_items);
  int get unreadCount => _unread;
  bool get connected => _ws.isConnected;

  Future<void> init() async {
    if (_listening) return;
    _listening = true;

    await _ws.connect();

    _ws.onNew.listen((n) {
      _items.insert(0, n);
      _unread = _items.where((e) => e.readAt == null).length;
      notifyListeners();
    });

    _ws.onUpdated.listen((n) {
      final idx = _items.indexWhere((e) => e.id == n.id);
      if (idx != -1) {
        _items[idx] = n;
      } else {
        _items.insert(0, n);
      }
      _unread = _items.where((e) => e.readAt == null).length;
      notifyListeners();
    });
  }

  void disposeWs() {
    _ws.dispose();
    _listening = false;
  }
}
