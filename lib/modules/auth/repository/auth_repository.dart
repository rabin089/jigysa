import 'models/login_request.dart';
import 'models/signup_request.dart';
import 'models/auth_response.dart';

abstract class AuthRepository {
  Future<AuthResponse> login(LoginRequest request);
  Future<AuthResponse> signup(SignupRequest request);
  Future<AuthResponse> googleLogin(String idToken);
}
