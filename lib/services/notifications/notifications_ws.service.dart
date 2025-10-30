import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:jigyasa/constant/api/api.url.constant.dart';
import 'package:jigyasa/services/local_storage/local_storage.services.dart';

import '../../modules/notifications/models/notification_model.dart';

class NotificationsWsService {
  static final NotificationsWsService _instance = NotificationsWsService._internal();
  factory NotificationsWsService() => _instance;
  NotificationsWsService._internal();

  IO.Socket? _socket;
  final StreamController<NotificationModel> _newController = StreamController<NotificationModel>.broadcast();
  final StreamController<NotificationModel> _updatedController = StreamController<NotificationModel>.broadcast();

  Stream<NotificationModel> get onNew => _newController.stream;
  Stream<NotificationModel> get onUpdated => _updatedController.stream;

  bool get isConnected => _socket?.connected == true;

  Future<void> connect() async {
    if (_socket != null && _socket!.connected) return;
    final token = await storageInstance.getData(key: 'accessToken');
    final socketBase = _socketBaseFromApi(ApiUrl.baseURL);
    final opts = IO.OptionBuilder()
        .setTransports(['websocket'])
        .setPath('/socket.io')
        .disableAutoConnect()
        .setExtraHeaders(token != null ? {'Authorization': 'Bearer $token'} : {})
        .setAuth(token != null ? {'token': token} : {})
        .enableReconnection()
        .build();
    _socket = IO.io(socketBase, opts);

    _socket!.onConnect((_) {});
    _socket!.onDisconnect((_) {});
    _socket!.on('notifications:new', (data) {
      try {
        if (data is Map) {
          final n = NotificationModel.fromJson(Map<String, dynamic>.from(data));
          _newController.add(n);
        }
      } catch (_) {}
    });
    _socket!.on('notifications:updated', (data) {
      try {
        if (data is Map) {
          final n = NotificationModel.fromJson(Map<String, dynamic>.from(data));
          _updatedController.add(n);
        }
      } catch (_) {}
    });

    _socket!.connect();
  }

  void disconnect() {
    _socket?.dispose();
    _socket = null;
  }

  String _socketBaseFromApi(String apiBase) {
    final uri = Uri.parse(apiBase);
    final scheme = uri.scheme == 'https' ? 'https' : 'http';
    final host = uri.host;
    final port = uri.hasPort ? ':${uri.port}' : '';
    return "$scheme://$host$port";
  }

  void dispose() {
    _newController.close();
    _updatedController.close();
    disconnect();
  }
}
