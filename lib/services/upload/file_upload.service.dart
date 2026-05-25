import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jigyasa/constant/api/api.url.constant.dart';
import 'package:jigyasa/services/http/dio_client.http.dart';
import 'package:jigyasa/services/local_storage/local_storage.services.dart';

typedef UploadProgress = void Function(int sentBytes, int totalBytes);

class UploadResult {
  final String? id;
  final String? url;
  final String filename;
  final int? size;

  const UploadResult({this.id, this.url, required this.filename, this.size});

  factory UploadResult.fromJson(Map<String, dynamic> json) {
    return UploadResult(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      url: json['url']?.toString() ?? json['downloadUrl']?.toString() ?? json['location']?.toString(),
      filename: (json['filename'] ?? json['name'] ?? '').toString(),
      size: json['size'] is int ? json['size'] as int : int.tryParse('${json['size'] ?? ''}'),
    );
  }
}

class FileUploadService {
  final Dio _dio;
  FileUploadService({Dio? dio}) : _dio = dio ?? apiClient.getDio();

  /// Obtain a presigned PUT URL from backend and upload bytes to it.
  Future<UploadResult> uploadWithPresignedPutBytes({
    required Uint8List bytes,
    required String filename,
    required String contentType,
    Map<String, dynamic>? signExtra,
    UploadProgress? onProgress,
  }) async {
    final signHeaders = await _buildHeaders();
    final signRes = await _dio.post(
      _resolve(ApiUrl.uploadFile),
      data: {
        'filename': filename,
        'contentType': contentType,
        if (signExtra != null) ...signExtra,
      },
      options: Options(headers: signHeaders, validateStatus: (s) => true),
    );
    if (signRes.statusCode == null || signRes.statusCode! < 200 || signRes.statusCode! >= 300) {
      throw Exception('Sign failed - status: ${signRes.statusCode}, body: ${signRes.data}');
    }

    final data = signRes.data is Map<String, dynamic>
        ? Map<String, dynamic>.from(signRes.data as Map)
        : signRes.data is Map
        ? Map<String, dynamic>.from(signRes.data as Map)
        : <String, dynamic>{};
    final payload = data['data'] is Map
        ? Map<String, dynamic>.from(data['data'] as Map)
        : data;

    String? presignedUrl = (payload['url'] ?? payload['uploadUrl'])?.toString();
    final objectUrl = (payload['objectUrl'] ?? payload['finalUrl'] ?? payload['publicUrl'])?.toString();
    if (presignedUrl == null || presignedUrl.isEmpty) {
      throw Exception('Signing response missing presigned URL');
    }

    // fix localhost -> remote replacement logic
    try {
      final up = Uri.parse(presignedUrl);
      if ((up.host == 'localhost' || up.host == '127.0.0.1') && objectUrl != null && objectUrl.isNotEmpty) {
        final pub = Uri.parse(objectUrl);
        final rebuilt = up.replace(scheme: pub.scheme, host: pub.host, port: pub.hasPort ? pub.port : up.port);
        presignedUrl = rebuilt.toString();
      }
    } catch (_) {}

    // ✅ FIX: Add Content-Length and send bytes directly
    final plainDio = Dio(BaseOptions(
      followRedirects: false,
      validateStatus: (s) => true,
    ));
    final putRes = await plainDio.put(
      presignedUrl!,
      data: bytes,
      options: Options(
        headers: {
          'Content-Type': contentType,
          'Content-Length': bytes.length.toString(),
        },
      ),
      onSendProgress: onProgress,
    );

    if (putRes.statusCode == null || putRes.statusCode! < 200 || putRes.statusCode! >= 300) {
      throw Exception('PUT upload failed - status: ${putRes.statusCode}, body: ${putRes.data}');
    }

    return UploadResult(filename: filename, url: objectUrl);
  }


  /// Same as above, but reads from a file path.
  Future<UploadResult> uploadWithPresignedPutFilePath({
    required String path,
    required String contentType,
    Map<String, dynamic>? signExtra,
    UploadProgress? onProgress,
  }) async {
    final file = File(path);
    final filename = path.split(Platform.pathSeparator).last;
    final bytes = await file.readAsBytes();
    return uploadWithPresignedPutBytes(
      bytes: bytes,
      filename: filename,
      contentType: contentType,
      signExtra: signExtra,
      onProgress: onProgress,
    );
  }

  Future<UploadResult> uploadBytes({
    required Uint8List bytes,
    required String filename,
    required String endpoint,
    String fieldName = 'file',
    Map<String, dynamic>? extraFields,
    UploadProgress? onProgress,
  }) async {
    final formData = FormData.fromMap({
      fieldName: MultipartFile.fromBytes(bytes, filename: filename),
      if (extraFields != null) ...extraFields,
    });

    final headers = await _buildHeaders();
    final url = _resolve(endpoint);

    try {
      final res = await _dio.post(
        url,
        data: formData,
        options: Options(
          headers: headers,
          validateStatus: (status) => true,
        ),
        onSendProgress: onProgress,
      );

      if (res.statusCode != null && res.statusCode! >= 200 && res.statusCode! < 300) {
        final data = res.data;
        if (data is Map<String, dynamic>) {
          final payload = (data['data'] is Map) ? Map<String, dynamic>.from(data['data']) : data;
          return UploadResult.fromJson(Map<String, dynamic>.from(payload));
        }
        return UploadResult(filename: filename, url: null);
      }

      throw Exception('Upload failed - status: ${res.statusCode}, body: ${res.data}');
    } on DioException catch (e) {
      debugPrint('Dio upload error: ${e.message}');
      rethrow;
    }
  }

  Future<UploadResult> uploadFilePath({
    required String path,
    required String endpoint,
    String fieldName = 'file',
    Map<String, dynamic>? extraFields,
    UploadProgress? onProgress,
  }) async {
    final file = File(path);
    final filename = path.split(Platform.pathSeparator).last;
    final formData = FormData.fromMap({
      fieldName: await MultipartFile.fromFile(file.path, filename: filename),
      if (extraFields != null) ...extraFields,
    });

    final headers = await _buildHeaders();
    final url = _resolve(endpoint);

    try {
      final res = await _dio.post(
        url,
        data: formData,
        options: Options(
          headers: headers,
          validateStatus: (status) => true,
        ),
        onSendProgress: onProgress,
      );

      if (res.statusCode != null && res.statusCode! >= 200 && res.statusCode! < 300) {
        final data = res.data;
        if (data is Map<String, dynamic>) {
          final payload = (data['data'] is Map) ? Map<String, dynamic>.from(data['data']) : data;
          return UploadResult.fromJson(Map<String, dynamic>.from(payload));
        }
        return UploadResult(filename: filename, url: null);
      }

      throw Exception('Upload failed - status: ${res.statusCode}, body: ${res.data}');
    } on DioException catch (e) {
      debugPrint('Dio upload error: ${e.message}');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _buildHeaders() async {
    String? tokenValue;
    try {
      final t = await storageInstance.getData(key: 'accessToken');
      if (t != null && t.startsWith('Bearer ')) {
        tokenValue = t.substring(7);
      } else {
        tokenValue = t;
      }
    } catch (_) {
      tokenValue = null;
    }
    return {
      if (tokenValue != null) 'X-Barrier-Token': tokenValue,
    };
  }

  String _resolve(String endpoint) {
    if (endpoint.startsWith('http://') || endpoint.startsWith('https://')) {
      return endpoint;
    }
    final base = ApiUrl.baseURL;
    if (endpoint.startsWith('/')) {
      return '$base$endpoint';
    }
    return '$base/$endpoint';
  }
}
