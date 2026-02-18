import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_ref/Utils/utils.dart';
import 'package:tennis_ref/models/jugador_model.dart';
import 'package:tennis_ref/models/theme_config_model.dart';
import 'package:tennis_ref/services/jugador_service.dart';

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