import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tennis_ref/controller/appController.dart';
import 'package:tennis_ref/models/partido_Response.dart';
import 'package:tennis_ref/models/partido_model.dart';
import 'package:tennis_ref/services/auth_service.dart';

class PartidoProvider extends ChangeNotifier{

  // URL y Conexiones
  final String _urlBase = 'api-tenis.duckdns.org';
  
  final String _apiPath = '/api/v1/partidos/';
  //Partidos
  List<Partido> partidosHistorial = [];
  List<Partido> partidosSinEmpezar = [];
  Partido? partidoEnJuego;

  // Observadores de estado
    bool isLoading = false;
    final AppController _logic = AppController();
    bool isSearching = false;
    int _pagePartidosOficiales = 0;
    String searchText = '';
    bool _hasMore = true;
  

  //Constructor
  PartidoProvider(){}

  void setSearching(bool value) {
    isSearching = value;
    if (!value) {
      searchText = '';
      getAllPatidos();
    }
    notifyListeners();
  }

  Future<String> _getJsonData(String path, Map<String, String> queryParameters) async {
    Uri uri = Uri.https(_urlBase,path, queryParameters);
    print(uri);
    Response response = await get(uri);
    return response.body;
  }


  getAllPatidos({String? query} ) async{
    isLoading = true;
    notifyListeners();

    if (query != null) searchText = query;

    final Map<String, String> queryParameters = {
      'estado': 'fin',
      'ordering': '-creado_en',
    };

    if (searchText.isNotEmpty) {
      queryParameters['search'] = searchText;
    }

    try {
      final jsonData = await _getJsonData(_apiPath, queryParameters);
      PartidoResponse partidosResponse = partidoResponseFromJson(jsonData);
      partidosHistorial = partidosResponse.results;
    } catch (e) {
      print('ERROR: $e');
    }
    isLoading = false;
    notifyListeners();
  }


  Future<void> getPartidosOficiales({String? query, bool resetPage = false}) async {
    if (isLoading) return;

    if (resetPage) {
      _pagePartidosOficiales = 1;
      partidosSinEmpezar = [];
      _hasMore = true;
    }

    if (!_hasMore) return;

    isLoading = true;
    notifyListeners();

    try {
      final Map<String, String> queryParameters = {
        'estado': 'pen',
        'ordering': '-creado_en',
        'page': _pagePartidosOficiales.toString(),
      };
      if (query != null && query.isNotEmpty) queryParameters['search'] = query;

      final responseBody = await _getJsonData(_apiPath, queryParameters);
      final partidoResponse = partidoResponseFromJson(responseBody);

      final nuevosFiltrados = partidoResponse.results.where((p) {
        bool noAmistoso = p.competicion.toLowerCase() != "amistoso";
        return noAmistoso; // Filtros adicionales aquí
      }).toList();

      partidosSinEmpezar.addAll(nuevosFiltrados);

      // Actualizamos si hay más páginas para la próxima vez
      if (partidoResponse.next != null) {
        _pagePartidosOficiales++;
      } else {
        _hasMore = false;
      }
      
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPartidosEmpezados({String? query, bool resetPage = false}) async {
    if (isLoading) return;

    if (resetPage) {
      _pagePartidosOficiales = 1;
      partidosSinEmpezar = []; // O crea una lista llamada partidosEmpezados
      _hasMore = true;
    }

    if (!_hasMore) return;

    isLoading = true;
    notifyListeners();

    try {
      final Map<String, String> queryParameters = {
        'estado': 'gam',
        'ordering': '-creado_en',
        'page': _pagePartidosOficiales.toString(),
      };
     
      if (query != null && query.isNotEmpty) queryParameters['search'] = query;

      final responseBody = await _getJsonData(_apiPath, queryParameters);
      final partidoResponse = partidoResponseFromJson(responseBody);

      partidosSinEmpezar.addAll(partidoResponse.results);

      if (partidoResponse.next != null) {
        _pagePartidosOficiales++;
      } else {
        _hasMore = false;
      }
      
    } catch (e) {
      print("Error en getPartidosEmpezados: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  partidoById(String partidoId) async {
    isLoading = true;
    notifyListeners();
    final _finalpah = '${_apiPath}$partidoId';
    Uri uri = Uri.https(_urlBase,_finalpah);
    try {
      Response response = await get(uri);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        partidoEnJuego = Partido.fromJson(data); 
        
        print("Partido cargado: ${partidoEnJuego!.id}");
      } else {
        print("Error al obtener partido: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fatal: $e");
    }

    isLoading = false;
    notifyListeners();
  }




  Future<void> postPartidoAmistoso() async {
    
    if (!await AuthService().estaLogueado()) return;
    isLoading = true;
    final userData = await AuthService().getMe();
    final userId = userData?['id']; 
    Uri uri = Uri.https(_urlBase, _apiPath);
    final token = await AuthService().getAccessToken();
    try{
      var response = await post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          'competicion': "Amistoso",
          'fase': "0",
          'annio': DateTime.now().year.toString(),
          'fecha_iniciado': DateTime.now().toIso8601String(),
          'is_tie_break': "false",
          'arbitro': userId.toString()
        },
      );
    if (response.statusCode == 401){
      bool refrescando = await AuthService().refreshToken();
      if (refrescando) return await postPartidoAmistoso();
      return ;
    }
    if (response.statusCode == 201 || response.statusCode == 200) {
      print("Partido creado correctamente");
      partidoEnJuego = Partido.fromJson(jsonDecode(response.body));      
      isLoading = false; 
      notifyListeners();
    } else {
      print("Error del servidor: ${response.body}");
      return ;
    }
    }catch(e){
      print("Error fatal: $e");
      return ;
    }
  }

  //PATCH 

  Future<void> inicioPartido() async {
  if (partidoEnJuego == null) return;

  partidoEnJuego!.estado = "gam";
  _logic.eligeSaque(partidoEnJuego!); 
  
  final userData = await AuthService().getMe(); 
  final userId = userData?['id']; 

  notifyListeners();

  try {
    final token = await AuthService().getAccessToken();
    final uri = Uri.https(_urlBase, '$_apiPath${partidoEnJuego!.id}/');
    
    final response = await patch(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'estado': 'gam',
        'arbitro': userId,
        'fecha_iniciado': DateTime.now().toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      
      for (var p in partidoEnJuego!.participantes) {
        await _patchParticipante(p);
      }
    } else {
      print("Error al sincronizar inicio: ${response.body}");
    }
  } catch (e) {
    print("Error de red al iniciar partido: $e");
  }
}

  Future<void> guardarEstadoPartido(Participante ganador, Participante perdedor) async {
    if (partidoEnJuego == null) return;

    final token = await AuthService().getAccessToken();
    final url = '$_apiPath${partidoEnJuego!.id}/';
    final uri = Uri.https(_urlBase, url);

    try {
      final response = await patch(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'estado': 'gam'
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        partidoEnJuego = Partido.fromJson(data);
        
        notifyListeners();
      } else {
        print("Error en PATCH: ${response.body}");
      }
    } catch (e) {
      print("Error fatal al realizar PATCH: $e");
    }
  }

  Future<void> _finalizarPartido() async {
  final token = await AuthService().getAccessToken();
  final uri = Uri.https(_urlBase, '$_apiPath${partidoEnJuego!.id}/finalizar/');

  var response = await post(
    uri,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'ganador_id': partidoEnJuego!.ganador,
      }),
    );
    partidoEnJuego = jsonDecode(response.body);
    notifyListeners();
  }

  //PUT

  Future<bool> guardarPartido(Partido partido) async {
    isLoading = true;
    notifyListeners();

    try {
      final token = await AuthService().getAccessToken();
      final url = Uri.parse('https://$_urlBase$_apiPath${partido.id}/');
      // Convertimos el modelo partido a JSON
      final String partidoJson = json.encode(partido.toJson());

      final response = await put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: partidoJson,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print("Error al actualizar: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error de red al guardar partido: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }











  // Logica de Partido en juego
  void sumarPuntoAlGanador(Participante ganador, Participante perdedor) async {
    if (partidoEnJuego == null) return;

    _logic.nuevoPunto(partidoEnJuego!, ganador, perdedor);

    notifyListeners();

    await _patchParticipante(ganador);
    await _patchParticipante(perdedor);
    
    if (partidoEnJuego!.ganador != null && partidoEnJuego!.ganador!.isNotEmpty) {
      await _finalizarPartido();
    }
  }
  
  Future<void> _patchParticipante(Participante p) async {
    final token = await AuthService().getAccessToken();
    final uri = Uri.https(_urlBase, '/api/v1/participantes/${p.id}/'); 

    try {
      final response = await patch(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', 
        },
        body: jsonEncode(p.toJson()), 
      );

      if (response.statusCode == 401) {
        if (await AuthService().refreshToken()) return _patchParticipante(p);
      }
      
      if (response.statusCode != 200) {
        print("Error PATCH Participante: ${response.body}");
      }
    } catch (e) {
      print("Error fatal en PATCH: $e");
    }
  }

  void eligePartido(Partido partido) {
    partidoEnJuego = partido;
    notifyListeners();
  }

  void deselecPartido(Partido partido) {
    if (partido != null && partido.id == partidoEnJuego!.id) partidoEnJuego = null;
    notifyListeners();
  }

}