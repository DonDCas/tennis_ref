import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tenis_pot3/models/jugadorResponse_model.dart';
import 'package:tenis_pot3/models/jugador_model.dart';

class JugadorProvider extends ChangeNotifier{

  // URL y Conexiones
  final String _urlBase = 'api-tenis.duckdns.org';
  
  final String _apiPath = '/api/v1/jugadores';
  //Temas
  List<Jugador> jugadores = [];


  // Observadores de estado
    bool isLoading = true;
    int _pageResult = 0;
  JugadorProvider(){
    getAllJugadores();
  }

  
  getAllJugadores() async{
    isLoading = true;
    _pageResult ++;
    final jsonData = await _getJsonData(_apiPath);
    final Map<String, dynamic> data = json.decode(jsonData);
    JugadorResponse partidosResponse = JugadorResponse.fromJson(data);
    jugadores = [...jugadores, ...partidosResponse.results];

    isLoading = false;
    notifyListeners();
  }
  
  Future<String> _getJsonData(String path, [int page = 1]) async {
    Uri uri = Uri.https(_urlBase,path,{'page':'$page'});
    print(uri);
    Response response = await get(uri);
    return response.body;
  }


}