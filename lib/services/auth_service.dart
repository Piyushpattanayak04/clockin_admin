// auth_service.dart

class AuthService {
  static final String _username = 'admin';
  static final String _password = 'admin123';

  static bool login(String username, String password) {
    return username == _username && password == _password;
  }
}