import 'dart:convert';
import 'package:http/http.dart';
import 'package:tennis_test_marcador/models/jugador_model.dart';

final String _ENDPOINT_BASE = "http://localhost:3002/api/v1/jugadores/";

class JugadorService {

  Future<Jugador?> getJugador(String id) async {
    Uri uri = Uri.parse('$_ENDPOINT_BASE$id');
    Response response = await get(uri);

    if (response.statusCode != 200) return null;
    
    final Map<String, dynamic> jsonMap = json.decode(response.body);

    print(jsonMap);
    return Jugador.fromJson(jsonMap['data']);
  }
  
}