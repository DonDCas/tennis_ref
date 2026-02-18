import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:tennis_ref/models/jugador_model.dart';
import 'package:uuid/uuid.dart';


final String _ENDPOINT_BASE = "http://api-tenis.duckdns.org/api/v1/jugadores/";

class JugadorService {

  Future<Jugador?> getJugador(String id) async {
    Uri uri = Uri.parse('$_ENDPOINT_BASE$id');
    Response response = await get(uri);

    
    if (response.statusCode != 200) return null;
    
    final Map<String, dynamic> jsonMap = json.decode(response.body);

    return Jugador.fromJson(jsonMap['data']);
  }

  Future<List<Jugador>> getJugadores() async {
    List<Jugador> jugadores = [];

    Uri uri = Uri.parse(_ENDPOINT_BASE);
    Response response = await get(uri);

    if (response.statusCode != 200) return jugadores;

    final List<dynamic> data = json.decode(response.body);

    print(data.runtimeType); // List<dynamic>
    print(data[0].runtimeType); // _Map<String, dynamic>

    jugadores = data
        .map((json) => Jugador.fromJson(json))
        .toList();

    return jugadores;
  }

  
}