import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  String _URL_ENDPOINT = 'https://api-tenis.duckdns.org/api/v1';
  final _storage = const FlutterSecureStorage();

  Future<bool> login(String user, String pass) async{
    Uri uri = Uri.parse('$_URL_ENDPOINT/token/');
    final response = await post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username' : user,
        'password' : pass,
      }),
    );
    if(response.statusCode != 200) return false;

    final data = jsonDecode(response.body);

    await _storage.write(key: 'accessToken', value:data['access']);
    await _storage.write(key: 'refreshToken', value:data['refresh']);

    return true;
  }
  Future<bool> estaLogueado() async{
    String? token = await getAccessToken();
    if (token == null) return false;

    return token.isNotEmpty;
  }

  Future<void> logout() async{
    await _storage.deleteAll();
  }

  Future<String?> getAccessToken() async{
    return await _storage.read(key: 'accessToken');
  }

  Future<bool> refreshToken() async{

    Uri uri = Uri.parse('$_URL_ENDPOINT/token/refresh/');
    final response = await post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'refresh' : await _storage.read(key: 'refreshToken'),
      }),
    );
    if(response.statusCode != 200) return false;

    final data = jsonDecode(response.body);

    await _storage.write(key: 'accessToken', value:data['access']);
    return true;
  }

  Future<Map<String, dynamic>?> getMe() async {
  final url = Uri.https(_URL_ENDPOINT, '/api/v1/user/me/');
  final token = await getAccessToken(); // Tu método para leer del disco

  if (token == null) return null;

  try {
    final resp = await get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode == 200) {
      return jsonDecode(resp.body); 
    } else if (resp.statusCode == 401) {
      print("Token inválido o expirado");
      bool refrescando = await refreshToken();
      if (refrescando) return getMe();
    }
  } catch (e) {
    print("Error conectando a /me: $e");
  }
  return null;
}

}