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
    final token = await AuthService().getAccessToken();

    try {
      // CAMBIO CLAVE: Usamos un post normal con JSON
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // OBLIGATORIO para Django
        },
        body: jsonEncode({
          'jugador_id': jugadorId,
          'es_jugador1': es_jugador1, // Pasamos el bool real, no un String
          // Los puntos y sets no los envíes, Django pondrá 0 por defecto
        }),
      );

      print("Status: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 401) {
        if (await AuthService().refreshToken()) {
          return await addParticipante(jugadorId, es_jugador1, partidoId);
        }
      }

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("¡Éxito!");
        notifyListeners();
      } else {
        print("Error del servidor: ${response.body}");
      }

    } catch (e) {
      print("Error fatal: $e");
    }
  }


  //PATCH
  Future<void> patchParticipante(Participante p) async {
    final token = await AuthService().getAccessToken();
    final uri = Uri.https(_urlBase, '$_apiPath${p.id}/'); 

    try {
      final response = await http.patch(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(p.toJson()),
      );

      if (response.statusCode == 401) {
        if (await AuthService().refreshToken()) await patchParticipante(p);
      }
      
      if (response.statusCode != 200) {
        print("Error al actualizar participante: ${response.body}");
      }
    } catch (e) {
      print("Error en PATCH participante: $e");
    }
  } 
}
  