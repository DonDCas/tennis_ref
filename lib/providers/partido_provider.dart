import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:tenis_pot3/models/partido_Response.dart';
import 'package:tenis_pot3/models/partido_model.dart';

class PartidoProvider extends ChangeNotifier{

  // URL y Conexiones
  final String _urlBase = 'api-tenis.duckdns.org';
  
  final String _apiPath = '/api/v1/partidos';
  //Temas
  List<Partido> partidosHistorial = [];

  // Observadores de estado
    bool isLoading = true;
  

  //Constructor
  PartidoProvider(){}

  getAllPatidos() async{
    isLoading = true;
    final jsonData = await _getJsonData(_apiPath);
    PartidoResponse partidosResponse = partidoResponseFromJson(jsonData);
    partidosHistorial = partidosResponse.results;
    print(partidosHistorial[0].competicion);

    isLoading = false;
    notifyListeners();
  }
  
  Future<String> _getJsonData(String path) async {
    Uri uri = Uri.https(_urlBase,path);
    print(uri);
    Response response = await get(uri);
    return response.body;
  }
}