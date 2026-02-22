import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tennis_ref/models/jugadorResponse_model.dart';
import 'package:tennis_ref/models/jugador_model.dart';
import 'package:tennis_ref/services/auth_service.dart';
import 'package:flutter/foundation.dart';

class JugadorProvider extends ChangeNotifier{

  // URL y Conexiones
  final String _urlBase = 'api-tenis.duckdns.org';
  
  final String _apiPath = '/api/v1/jugadores/';
  //Temas
  List<Jugador> jugadores = [];
  late Jugador jugadorEnJuego1;
  late Jugador jugadorEnJuego2;

  // Observadores de estado
    bool isLoading = true;
    int _pageResult = 0;
    
  JugadorProvider(){
    getAllJugadores();
  }

  // GETs
  Future<String> _getJsonData(String path, [int page = 1]) async {
    Uri uri = Uri.https(_urlBase,path,{'page':'$page'});
    Response response = await get(uri);
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
    isLoading = false;
    notifyListeners();
  }

  Future<Jugador?> getJugadorById(String jugadorId) async {
    final pathPorId = _apiPath+jugadorId;
    final jsonData = await _getJsonData(pathPorId);
    if (jsonData.isEmpty) return null ;
    final Map<String, dynamic> data = json.decode(jsonData);
    return Jugador.fromJson(data);
  }

  Future<void> prepararJugadorEnJuego(String jugadorId, bool esJugador1) async {
    isLoading = true;
    notifyListeners();
    final Jugador? jugadorTemp = await getJugadorById(jugadorId);
    
    if(jugadorTemp != null){
      if (esJugador1) {
        jugadorEnJuego1 = jugadorTemp;
      } else {
        jugadorEnJuego2 = jugadorTemp;
      }

    }
    isLoading = false;
    notifyListeners();
  }

  //POSTs
  
  Future<Jugador?> crearJugador(Jugador jugador, Uint8List imagenBytes, String filename) async {
    if (!await AuthService().estaLogueado()) return null;

    final uri = Uri.https(_urlBase, '$_apiPath'); 
    final token = await AuthService().getAccessToken();

    try {
      var request = MultipartRequest('POST', uri);

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

      request.files.add(
      MultipartFile.fromBytes(
        'foto', 
        imagenBytes,
        filename: filename,
        contentType: MediaType('image', 'jpeg'), 
      ),
    );
      
      var streamedResponse = await request.send();
      var response = await Response.fromStream(streamedResponse);

      if (response.statusCode == 401) {
        bool refrescando = await AuthService().refreshToken();
        if (refrescando) return await crearJugador(jugador, imagenBytes, filename);
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
  