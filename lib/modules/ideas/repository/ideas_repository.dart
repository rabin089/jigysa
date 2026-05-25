import 'package:dio/dio.dart';
import 'package:jigyasa/constant/api/api.url.constant.dart';
import 'package:jigyasa/services/http/dio_client.http.dart';
import '../models/idea.dart';

abstract class IdeasRepository {
  Future<List<Idea>> getAllIdeas();
  Future<Idea> createIdea(Map<String, dynamic> payload);
}

class IdeasRepositoryImpl implements IdeasRepository {
  final Dio _dio;
  IdeasRepositoryImpl({Dio? dio}) : _dio = dio ?? apiClient.getDio();

  @override
  Future<List<Idea>> getAllIdeas() async {
    final res = await _dio.get(ApiUrl.getAllIdeas);
    final data = res.data;
    if (data is List) {
      return data.map((e) => Idea.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    }
    if (data is Map<String, dynamic>) {
      final list = data['data'] ?? data['items'] ?? data['results'];
      if (list is List) {
        return list
            .map((e) => Idea.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
    }
    return <Idea>[];
  }

  @override
  Future<Idea> createIdea(Map<String, dynamic> payload) async {
    final res = await _dio.post(ApiUrl.createIdea, data: payload);
    final data = res.data;
    if (data is Map<String, dynamic>) {
      final obj = data['data'] is Map<String, dynamic> ? data['data'] as Map<String, dynamic> : data;
      return Idea.fromJson(Map<String, dynamic>.from(obj));
    }
    throw Exception('Invalid response while creating idea');
  }
}
