import 'dart:convert';
import 'package:http/http.dart';
import 'package:tenis_pot3/models/jugador_model.dart';


final String _ENDPOINT_BASE = "https://api-tenis-03vs.onrender.com/api/v1/Jugadores/";

class JugadorService {

  Future<Jugador?> getJugador(String id) async {
    Uri uri = Uri.parse('$_ENDPOINT_BASE$id');
    Response response = await get(uri);

    
    if (response.statusCode != 200) return null;
    
    final Map<String, dynamic> jsonMap = json.decode(response.body);

    return Jugador.fromJson(jsonMap['data']);
  }

  Future<List<Jugador?>> getJugadores() async{
    List<Jugador> jugadores = [];
    Uri uri = Uri.parse(_ENDPOINT_BASE);
    Response response = await get(uri);

    if (response.statusCode != 200) return jugadores;

    final Map<String, dynamic> decoded = json.decode(response.body);

    final List data = decoded["data"];
  
    
  return data
      .map((jsonJugador) => Jugador.fromJson(jsonJugador))
      .toList();

  }
  
}