import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tennis_ref/models/partido_Response.dart';
import 'package:tennis_ref/models/partido_model.dart';
import 'package:tennis_ref/services/auth_service.dart';

class PartidoProvider extends ChangeNotifier{

  // URL y Conexiones
  final String _urlBase = 'api-tenis.duckdns.org';
  
  final String _apiPath = '/api/v1/partidos/';
  //Partidos
  List<Partido> partidosHistorial = [];
  Partido? partidoEnJuego;

  // Observadores de estado
    bool isLoading = true;
  

  //Constructor
  PartidoProvider(){}


  Future<String> _getJsonData(String path, Map<String, String> queryParameters) async {
    Uri uri = Uri.https(_urlBase,path);
    print(uri);
    Response response = await get(uri);
    return response.body;
  }
  getAllPatidos() async{
    isLoading = true;
    notifyListeners();
    final queryParameters = {
      'estado': 'fin',
    };
    final jsonData = await _getJsonData(_apiPath, queryParameters);
    PartidoResponse partidosResponse = partidoResponseFromJson(jsonData, queryParameters);
    partidosHistorial = partidosResponse.results;
    print(partidosHistorial[0].competicion);

    isLoading = false;
    notifyListeners();
  }
  Future<void> postPartidoAmistoso() async {
    // Usuario iniciado?
    if (!await AuthService().estaLogueado()) return;
    isLoading = true;
    final userData = await AuthService().getMe(); // Esperas a que llegue el Map
    final userId = userData?['id']; 
    Uri uri = Uri.https(_urlBase, _apiPath);
    final token = await AuthService().getAccessToken();
    try{
      var response = await post(
        uri,
        headers: {
          'Authorization': 'Bearer $token', // Aquí es donde se envía realmente
        },
        body: {
          'competicion': "Amistoso",
          'fase': "0",
          'annio': DateTime.now().year.toString(),
          'fecha_iniciado': DateTime.now().toIso8601String(),
          'is_tie_break': "false",
          'arbitro': userId.toString(),
        },
      );
      
    if (response.statusCode == 401){
      bool refrescando = await AuthService().refreshToken();
      if (refrescando) return await postPartidoAmistoso();
      return ;
    }
    print(response.body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      print("Partido creado correctamente");
      partidoEnJuego = Partido.fromJson(jsonDecode(response.body));      
      isLoading = false; 
      notifyListeners();
      ;
    } else {
      print("Error del servidor: ${response.body}");
      return ;
    }
    }catch(e){
      print("Error fatal: $e");
      return ;
    }


  }
}