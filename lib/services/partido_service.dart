import 'dart:convert';
import 'package:http/http.dart';
import 'package:tennis_test_marcador/models/partido_model.dart';

final String _ENDPOINT_BASE = "http://localhost:3002/api/v1/Game/";

class PartidoService {

  Future<Partido?> getPartido(String id) async {
    Uri uri = Uri.parse('$_ENDPOINT_BASE$id');
    Response response = await get(uri);

    if (response.statusCode != 200) return null;
    
    final Map<String, dynamic> jsonMap = json.decode(response.body);

    print(jsonMap);
    return Partido.fromJson(jsonMap['data']);
  }
  
}