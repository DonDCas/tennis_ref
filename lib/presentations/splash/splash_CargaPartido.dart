import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennis_ref/Utils/utils.dart';
import 'package:tennis_ref/models/jugador_model.dart';
import 'package:tennis_ref/models/partido_model.dart';
import 'package:tennis_ref/models/theme_config_model.dart';
import 'package:tennis_ref/providers/participantes_provider.dart';
import 'package:tennis_ref/providers/partido_provider.dart';
import 'package:tennis_ref/providers/tema_provider.dart';

class SplashCargaPartido extends StatefulWidget {
  String jugador1Id;
  String jugador2Id;

  SplashCargaPartido({super.key, required this.jugador1Id, required this.jugador2Id});

  @override
  State<SplashCargaPartido> createState() => _SplashCargaPartidoState();
}

class _SplashCargaPartidoState extends State<SplashCargaPartido> {
  @override
  Widget build(BuildContext context) {
    PartidoProvider partidoProvider = Provider.of<PartidoProvider>(context);
    TemaConfig tema = Provider.of<TemaProvider>(context).temaMarcador;
    Partido? partido = Provider.of<PartidoProvider>(context).partidoEnJuego;
    @override
    void initState() {
      PartidoProvider partidoProvider = Provider.of<PartidoProvider>(context);
      super.initState();
      crearPartido(partidoProvider);
    }
    return Scaffold(
      backgroundColor: Color(Utils.parseHex(tema.primaryColor)),
      body: (!partidoProvider.isLoading) ? Center(child: CircularProgressIndicator(),): Center(child: Text("hola", style: TextStyle(color: Colors.white),)),
    );
  }
  
  void crearPartido(PartidoProvider partidoProvider) {
    partidoProvider.postPartidoAmistoso();
    Provider.of<ParticipanteProvider>(context).crearParticipante(widget.jugador1Id, true);
    Provider.of<ParticipanteProvider>(context).crearParticipante(widget.jugador2Id, false);
  }
}