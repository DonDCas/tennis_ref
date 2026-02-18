import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tennis_ref/models/theme_config_model.dart';

class TemaProvider extends ChangeNotifier{
  
  // URL y Conexiones
  String _urlBase = 'https://api-tenis-config-default-rtdb.europe-west1.firebasedatabase.app/Tema';

  //Temas
  TemaConfig? temaMenu;
  late TemaConfig temaMarcador;

  // Observadores de estado
    bool isLoading = true;
  

  //Constructor
  TemaProvider(){
    this.getTemaMenu();
    this.getTemaMarcador();
  }
  getTemaMenu() async{
    try{
      final jsonData = await getJsonData('/Menu.json');
      temaMenu = temaConfigFromJson(jsonData);
    } catch (e){
      print('error cargando tema: $e');
    } finally{
      isLoading = false;
      notifyListeners();
    }
  }

  getTemaMarcador() async {
    try{
      final jsonData = await getJsonData('/Marcador.json');
      await Future.delayed(Duration(seconds: 2));
      temaMarcador = temaConfigFromJson(jsonData);
    } catch (e){
      print('error cargando tema: $e');
    } finally{
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String> getJsonData(String endpoint) async{
    final url = Uri.parse('${_urlBase + endpoint}');
    Response response = await get(url);
    return response.body;
  }
 
}