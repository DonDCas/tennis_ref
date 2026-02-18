import 'dart:convert';
import 'package:http/http.dart';
import 'package:tennis_ref/models/partido_model.dart';

final String _ENDPOINT_BASE = "https://api-tenis-03vs.onrender.com/api/v1/Game/";

class PartidoService {

  Future<Partido?> getPartido(String id) async {
    Uri uri = Uri.parse('$_ENDPOINT_BASE/$id');
    Response response = await get(uri);

    if (response.statusCode != 200) return null;
    
    final Map<String, dynamic> jsonMap = json.decode(response.body);

    // Aseguramos que las listas existan
    final Map<String, dynamic> data = jsonMap['data'];
    data['sets_e1'] ??= [0, 0, 0];
    data['sets_e2'] ??= [0, 0, 0];
    data['sets_ganadores'] ??= [null, null, null];

    return Partido.fromJson(data);
  }

  Future<Partido?> getPrimerPartido() async {
    Uri uri = Uri.parse(_ENDPOINT_BASE);
    final response = await get(uri);

    if (response.statusCode != 200) return null;

    final Map<String, dynamic> jsonMap = json.decode(response.body);
    final List<dynamic> data = jsonMap['data'];

    final List<Partido> partidos = data.map((e) {
      final Map<String, dynamic> map = e as Map<String, dynamic>;
      map['sets_e1'] ??= [0, 0, 0];
      map['sets_e2'] ??= [0, 0, 0];
      map['sets_ganadores'] ??= [null, null, null];
      return Partido.fromJson(map);
    }).toList();

    // Devuelve el primer partido sin fechaJugado
    for (final p in partidos) {
      if (p.ganador == null) {
        return p;
      }
    }
    return null;
  }

  Future<List<Partido?>> getPartidos() async {
    List<Partido> partidos = [];
    Uri uri = Uri.parse(_ENDPOINT_BASE);
    final response = await get(uri);

    if (response.statusCode != 200) return partidos;

    final Map<String, dynamic> jsonMap = json.decode(response.body);
    final List<dynamic> data = jsonMap['data'];

    partidos = data.map((e) {
      final Map<String, dynamic> map = e as Map<String, dynamic>;
      map['sets_e1'] ??= [0, 0, 0];
      map['sets_e2'] ??= [0, 0, 0];
      map['sets_ganadores'] ??= [null, null, null];
      return Partido.fromJson(map);
    }).toList();

    return partidos;
  }


  Future<bool> guardarPartido(Partido partido) async {
  // Asegurarse de la barra
  Uri uri = Uri.parse('$_ENDPOINT_BASE${partido.id}');
  try {
    final response = await patch(
      uri,
      headers: {"Content-Type": "application/json"},
      body: json.encode(partido.toJson()),
    );

    String bodyEnviado = json.encode(partido.toJson());
    print(partido.id);
    print(response.statusCode);


    return response.statusCode == 200 || response.statusCode == 201;
  } catch (e) {
    print("Error en guardarPartido: $e");
    return false;
  }
}

}
