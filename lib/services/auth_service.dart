import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  // bikin login default pertama kali
  static Future<void> initDefaultLogin() async {

    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('username')) {
      await prefs.setString('username', 'user');
    }

    if (!prefs.containsKey('password')) {
      await prefs.setString('password', 'user');
    }
  }

  // cek login
  static Future<bool> login(
    String username,
    String password,
  ) async {

    final prefs = await SharedPreferences.getInstance();

    final savedUsername =
        prefs.getString('username') ?? 'user';

    final savedPassword =
        prefs.getString('password') ?? 'user';

    return username == savedUsername &&
        password == savedPassword;
  }

  // update akun
  static Future<void> updateAccount(
    String username,
    String password,
  ) async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('username', username);

    await prefs.setString('password', password);
  }

  // ambil username
  static Future<String> getUsername() async {

    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('username') ?? 'user';
  }

  // ambil password
  static Future<String> getPassword() async {

    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('password') ?? 'user';
  }
}