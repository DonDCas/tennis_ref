import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:tenis_pot3/models/jugador_model.dart';
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

  Future<Jugador?> crearJugador({
      required String nombreCompleto,
      required String pais,
      required String fechaNacimiento,
      required int rankingAtp,
      required int mejorRanking,
      required String manoDominante,
      File? image,
    }) async{
      final uri = Uri.parse(_ENDPOINT_BASE);
      final request = MultipartRequest('POST', uri);

      request.fields.addAll({
        'id': Uuid().v4(),
        'nombre_completo': nombreCompleto,
        'pais': pais,
        'fecha_nacimiento': fechaNacimiento,
        'ranking_atp': rankingAtp.toString(),
        'mejor_ranking': mejorRanking.toString(),
        'mano_dominante': manoDominante,
        'creacion': DateTime.now().toIso8601String(),
        'actualizacion': DateTime.now().toIso8601String(),
      });

      if (image != null){
        request.files.add(
          await MultipartFile.fromPath('foto', image.path),
        );
      }
      final response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 201){
        final body = await response.stream.bytesToString();
        return Jugador.fromJson(
          Map<String, dynamic>.from(jsonDecode(body))
        );
      }
    }
    
  
}