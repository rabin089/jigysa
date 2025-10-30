import 'package:jigyasa/modules/auth/repository/auth_repository.dart';
import 'package:jigyasa/modules/auth/repository/auth_repository_impl.dart';
import 'package:jigyasa/modules/auth/repository/models/auth_response.dart';
import 'package:jigyasa/modules/auth/repository/models/login_request.dart';
import 'package:jigyasa/modules/auth/repository/models/signup_request.dart';
import 'package:jigyasa/services/local_storage/local_storage.services.dart';

class AuthService {
  final AuthRepository _repo;
  final LocalStorageService _storage;

  AuthService({AuthRepository? repo, LocalStorageService? storage})
    : _repo = repo ?? AuthRepositoryImpl(),
      _storage = storage ?? storageInstance;

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final res = await _repo.login(
      LoginRequest(email: email, password: password),
    );
    if (res.accessToken.isNotEmpty) {
      await _storage.saveToken(res.accessToken);
      // Debug: confirm token saved (masked)
      try {
        final stored = await storageInstance.getData(key: 'accessToken');
        final masked =
            stored != null && stored.length > 10
                ? '${stored.substring(0, 6)}...${stored.substring(stored.length - 4)}'
                : stored;
        // use debugPrint from Flutter
        // ignore: avoid_print
        print('AuthService.login - token saved: ${masked ?? 'null'}');
      } catch (_) {}
      if (res.user != null) {
        await _storage.saveUserProfile(
          id: res.user!.id,
          email: res.user!.email,
          name: res.user!.name,
          username: res.user!.username,
        );
      }
    }
    return res;
  }

  Future<AuthResponse> signup({
    required String fullName,
    required String username,
    required String email,
    required String password,
  }) async {
    final res = await _repo.signup(
      SignupRequest(
        fullName: fullName,
        username: username,
        email: email,
        password: password,
      ),
    );
    if (res.accessToken.isNotEmpty) {
      await _storage.saveToken(res.accessToken);
      if (res.user != null) {
        await _storage.saveUserProfile(
          id: res.user!.id,
          email: res.user!.email,
          name: res.user!.name,
          username: res.user!.username,
        );
      }
    }
    return res;
  }
}

AuthService get authService => AuthService();
