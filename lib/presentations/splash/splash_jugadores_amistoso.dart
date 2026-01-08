import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tenis_pot3/Utils/utils.dart';
import 'package:tenis_pot3/models/jugador_model.dart';
import 'package:tenis_pot3/models/theme_config_model.dart';
import 'package:tenis_pot3/services/jugador_service.dart';

class SplashJugadoresAmistosos extends StatefulWidget {
  TemaConfig temaConfig;
  SplashJugadoresAmistosos({super.key, required TemaConfig this.temaConfig});

  @override
  State<SplashJugadoresAmistosos> createState() => _SplashJugadoresAmistososState();
}

class _SplashJugadoresAmistososState extends State<SplashJugadoresAmistosos> {
  List<Jugador> jugadores = [];
  @override
  void initState(){
      cargarJugadores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Utils.parseHex(widget.temaConfig.primaryColor)),
      body: Center(
        child: Image.asset("assets/gif/Tennis_Ball.gif") ,
      )
    );
  }

  void cargarJugadores() async{
    JugadorService jugadorService = JugadorService();
    final data = await jugadorService.getJugadores();
    if (data != null){
      setState(() {
        jugadores = data as List<Jugador>;
        context.go('/selectjugadores', extra: {'tema': widget.temaConfig, 'jugadores': jugadores});
      });
    }
  }
}