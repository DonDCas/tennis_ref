import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tennis_ref/models/jugadorResponse_model.dart';
import 'package:tennis_ref/models/jugador_model.dart';
import 'package:tennis_ref/services/auth_service.dart';

class JugadorProvider extends ChangeNotifier{

  // URL y Conexiones
  final String _urlBase = 'api-tenis.duckdns.org';
  
  final String _apiPath = '/api/v1/jugadores/';
  //Temas
  List<Jugador> jugadores = [];


  // Observadores de estado
    bool isLoading = true;
    int _pageResult = 0;
  JugadorProvider(){
    getAllJugadores();
  }

  // GETs
  Future<String> _getJsonData(String path, [int page = 1]) async {
    Uri uri = Uri.https(_urlBase,path,{'page':'$page'});
    http.Response response = await http.get(uri);
    if (response.statusCode != 200) return '';
    return response.body;
  }
  
  getAllJugadores() async{
    isLoading = true;
    _pageResult ++;
    final jsonData = await _getJsonData(_apiPath, _pageResult);
    if (jsonData.isEmpty) return;
    final Map<String, dynamic> data = json.decode(jsonData);
    JugadorResponse partidosResponse = JugadorResponse.fromJson(data);
    jugadores = [...jugadores, ...partidosResponse.results];
    print(jugadores[jugadores.length-1]);
    isLoading = false;
    notifyListeners();
  }
  

  //POSTs
  
  Future<http.Response?> _postJsonData(String json) async {
  final uri = Uri.https(_urlBase, _apiPath);
  
  try {
    var response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await AuthService().getAccessToken()}'
      },
      body: json
    );

    if (response.statusCode == 401) {
      print("Token Caducado");
      bool refrescando = await AuthService().refreshToken();
      if (!refrescando) return response; // Devuelve el 401 original
      
      print("Token refrescado, reintentando petición...");
      return await _postJsonData(json); // REINTENTO
    }
    print("Respuesta servidor (${response.statusCode}): ${response.body}");
    
    return response;
  } catch (e) {
    print("Error en la conexión: $e");
    return null;
  }
}
Future<Jugador?> crearJugador(Jugador jugador, File imagen) async {
  if (!await AuthService().estaLogueado()) return null;

  final uri = Uri.https(_urlBase, '$_apiPath'); 
  print(uri);
  final token = await AuthService().getAccessToken();

  try {
    var request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });

    request.fields['nombre_completo'] = jugador.nombreCompleto;
    request.fields['pais'] = jugador.pais;
    request.fields['bandera'] = jugador.bandera ?? '';
    request.fields['fecha_nacimiento'] = "${jugador.fechaNacimiento.year.toString().padLeft(4, '0')}-${jugador.fechaNacimiento.month.toString().padLeft(2, '0')}-${jugador.fechaNacimiento.day.toString().padLeft(2, '0')}";
    request.fields['ranking_atp'] = jugador.rankingAtp.toString();
    request.fields['mejor_ranking'] = jugador.mejorRanking.toString();
    request.fields['mano_dominante'] = jugador.manoDominante;

    var stream = http.ByteStream(imagen.openRead());
    var length = await imagen.length();
    var multipartFile = http.MultipartFile('foto', stream, length,
        filename: imagen.path.split('/').last);
    
    request.files.add(multipartFile);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 401) {
      bool refrescando = await AuthService().refreshToken();
      if (refrescando) return await crearJugador(jugador, imagen);
      return null;
    }

    if (response.statusCode == 201 || response.statusCode == 200) {
      print("Jugador creado correctamente");
      final nuevoJugador = Jugador.fromJson(jsonDecode(response.body));
      jugadores.add(nuevoJugador);
      notifyListeners();
      return nuevoJugador;
    } else {
      print("Error del servidor: ${response.body}");
      return null;
    }

  } catch (e) {
    print("Error fatal: $e");
    return null;
  }
}
}
  