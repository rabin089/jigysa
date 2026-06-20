import 'package:dio/dio.dart';
import 'package:jigyasa/constant/api/api.url.constant.dart';
import 'package:jigyasa/services/http/dio_client.http.dart';

import 'auth_repository.dart';
import 'models/login_request.dart';
import 'models/signup_request.dart';
import 'models/auth_response.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;
  AuthRepositoryImpl({Dio? dio}) : _dio = dio ?? apiClient.getDio();

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    final res = await _dio.post(ApiUrl.loginApi, data: request.toJson());
    return AuthResponse.fromJson(res.data is Map<String, dynamic>
        ? res.data as Map<String, dynamic>
        : <String, dynamic>{});
  }

  @override
  Future<AuthResponse> signup(SignupRequest request) async {
    final res = await _dio.post(ApiUrl.signupApi, data: request.toJson());
    return AuthResponse.fromJson(res.data is Map<String, dynamic>
        ? res.data as Map<String, dynamic>
        : <String, dynamic>{});
  }

  @override
  Future<AuthResponse> googleLogin(String idToken) async {
    final res = await _dio.post(ApiUrl.googleLogin, data: {'idToken': idToken});
    return AuthResponse.fromJson(res.data is Map<String, dynamic>
        ? res.data as Map<String, dynamic>
        : <String, dynamic>{});
  }
}
