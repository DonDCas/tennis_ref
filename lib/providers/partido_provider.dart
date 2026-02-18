import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tennis_ref/models/partido_Response.dart';
import 'package:tennis_ref/models/partido_model.dart';
import 'package:tennis_ref/services/auth_service.dart';

class PartidoProvider extends ChangeNotifier{

  // URL y Conexiones
  final String _urlBase = 'api-tenis.duckdns.org';
  
  final String _apiPath = '/api/v1/partidos';
  //Partidos
  List<Partido> partidosHistorial = [];
  Partido? partidoEnJuego;

  // Observadores de estado
    bool isLoading = true;
  

  //Constructor
  PartidoProvider(){}


  Future<String> _getJsonData(String path) async {
    Uri uri = Uri.https(_urlBase,path);
    print(uri);
    Response response = await get(uri);
    return response.body;
  }
  getAllPatidos() async{
    isLoading = true;
    final jsonData = await _getJsonData(_apiPath);
    PartidoResponse partidosResponse = partidoResponseFromJson(jsonData);
    partidosHistorial = partidosResponse.results;
    print(partidosHistorial[0].competicion);

    isLoading = false;
    notifyListeners();
  }
  void postPartidoAmistoso() async {
    // Usuario iniciado?
    if (!await AuthService().estaLogueado()) return;
    isLoading = true;
    final userData = await AuthService().getMe(); // Esperas a que llegue el Map
    final userId = userData?['id']; 
    Uri uri = Uri.https(_urlBase, _apiPath);
    final token = await AuthService().getAccessToken();
    try{
      var request = MultipartRequest('POST',uri);
      request.headers.addAll({
        'Authorization' : 'Baerer $token',
      });
      request.fields['competicion'] = "Amistoso";
      request.fields['fase'] = "0";
      request.fields['annio'] = DateTime.now().year.toString() ;
      request.fields['fecha_iniciado'] = DateTime.now().toIso8601String() ;
      request.fields['is_tie_break'] = false.toString();
      request.fields['arbitro'] = userId.toString();
      

    var response = await post(uri, body: request.fields);

    if (response.statusCode == 401){
      bool refrescando = await AuthService().refreshToken();
      if (refrescando) return postPartidoAmistoso();
      return null;
    }

    if (response.statusCode == 201 || response.statusCode == 200) {
      print("Partido creado correctamente");
      partidoEnJuego = Partido.fromJson(jsonDecode(response.body));      
      isLoading = false; 
      notifyListeners();
      ;
    } else {
      print("Error del servidor: ${response.body}");
      return null;
    }
    }catch(e){
      print("Error fatal: $e");
      return null;
    }


  }
}