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

  ParticipanteProvider(){
    //getAllJugadores();
  }
 
  // GETs
  Future<String> _getJsonData(String path, [int page = 1]) async {
    Uri uri = Uri.https(_urlBase,path,{'page':'$page'});
    http.Response response = await http.get(uri);
    if (response.statusCode != 200) return '';
    return response.body;
  } 

  //POSTs
  
  addParticipante(String jugadorId, bool es_jugador1, String partidoId) async {
    if (!await AuthService().estaLogueado()) return null;
    final pathFinal = "$_apiPath/$partidoId/add-jugador/";
    final uri = Uri.https(_urlBase, pathFinal); 
    print(uri);
    final token = await AuthService().getAccessToken();

    try {
      var request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      request.fields['jugador_id'] = jugadorId;
      request.fields['es_jugador1'] = es_jugador1.toString();
      request.fields['sets_1'] = "0";
      request.fields['sets_2'] = "0";
      request.fields['sets_3'] = "0";
      request.fields['saque'] = "false";
    

      var response = await post(uri,body:request);

      if (response.statusCode == 401) {
        bool refrescando = await AuthService().refreshToken();
        if (refrescando) return await addParticipante(jugadorId, es_jugador1, partidoId);
        return null;
      }

      if (response.statusCode == 201 || response.statusCode == 200) {
        
        notifyListeners();
        return ;
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
  