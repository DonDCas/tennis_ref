import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  String _URL_ENDPOINT = 'http://10.0.2.2:8000/api/v1';
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
    print("Hola");
    print(response.statusCode);
    if(response.statusCode != 200) return false;

    final data = jsonDecode(response.body);

    await _storage.write(key: 'accessToken', value:data['access']);
    await _storage.write(key: 'refreshToken', value:data['refresh']);

    return true;
  }

  Future<void> logout() async{
    await _storage.deleteAll();
  }

  Future<String?> getAccessToken() async{
    return await _storage.read(key: 'accessToken');
  }
}