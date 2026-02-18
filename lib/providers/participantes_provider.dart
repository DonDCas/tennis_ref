import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:tennis_ref/models/jugadorResponse_model.dart';
import 'package:tennis_ref/models/jugador_model.dart';
import 'package:tennis_ref/models/partido_model.dart';
import 'package:tennis_ref/services/auth_service.dart';

class ParticipanteProvider extends ChangeNotifier{

  // URL y Conexiones
  final String _urlBase = 'api-tenis.duckdns.org';
  
  final String _apiPath = '/api/v1/participantes';
  //Participantes
  Participante? nuevoParticipante;


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
  
 
Future<Participante?> crearParticipante(String jugadorId, bool es_jugador1) async {
  if (!await AuthService().estaLogueado()) return null;

  final uri = Uri.https(_urlBase, '$_apiPath'); 
  print(uri);
  final token = await AuthService().getAccessToken();

  try {
    var request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });

    request.fields['jugador'] = jugadorId;
    request.fields['es_jugador1'] = es_jugador1.toString();
    request.fields['sets_1'] = "0";
    request.fields['sets_2'] = "0";
    request.fields['sets_3'] = "0";
    request.fields['saque'] = "false";
  

    var response = await post(uri,body:request);

    if (response.statusCode == 401) {
      bool refrescando = await AuthService().refreshToken();
      if (refrescando) return await crearParticipante(jugadorId, es_jugador1);
      return null;
    }

    if (response.statusCode == 201 || response.statusCode == 200) {
      print("Participante creado correctamente");
      final nuevoParticipante = Jugador.fromJson(jsonDecode(response.body));
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
  