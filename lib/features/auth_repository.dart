import 'dart:convert';

import 'package:http/http.dart' as http;

import '../services/google_auth_service.dart';
import '../services/token_service.dart';

class AuthRepository {
  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("http://192.168.3.119:8080/authen"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 &&
        data["result"] != null &&
        data["result"]["authenticated"] == true) {
      final token = data["result"]["token"];
      await TokenService.save(token);

      return true;
    }

    return false;
  }

  Future<bool> register({
    required String username,
    required String password,
    required String dob,
  }) async {
    final response = await http.post(
      Uri.parse("http://192.168.3.119:8080/api/v1/users/signup"), //10.0.2.2
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
        "dob": dob,
        "role": ["USER"],
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["code"] == 1000) {
      return true; // đăng ký thành công
    }

    return false;
  }

  Future<void> logoutFlow(String token) async {
    await GoogleAuthService().signOutGoogle(); // nếu có login Google

    await http.post(
      Uri.parse("http://192.168.3.119:8080/authen/logout"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"token": token}),
    );

    await TokenService.clear();
  }

  Future<bool> loginWithGoogle(String idToken) async {
    final response = await http.post(
      Uri.parse("http://192.168.3.119:8080/autheng/api/v1/auth/google"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"idToken": idToken}),
    );
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["result"]["authenticated"] == true) {
      final token = data["result"]["token"];

      await TokenService.save(token); // lưu JWT backend
      return true;
    }

    return false;
  }
}
