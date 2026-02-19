import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tennis_ref/Utils/utils.dart';
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
    void initState() {
      super.initState();
      Future.microtask(() => _crearPartido());

    }

     Future<void> _crearPartido() async{
      PartidoProvider partidoProvider = Provider.of<PartidoProvider>(context, listen: false);
      ParticipanteProvider participantesProvider = Provider.of<ParticipanteProvider>(context, listen: false);
      await partidoProvider.postPartidoAmistoso();
      if (partidoProvider.partidoEnJuego != null){
        final partidoId = partidoProvider.partidoEnJuego!.id;
        await participantesProvider.addParticipante(widget.jugador1Id, true, partidoId);
        await participantesProvider.addParticipante(widget.jugador2Id, false, partidoId); 

        if (mounted) {
        context.go('/partido');
       }
      }
    }
  @override
  Widget build(BuildContext context) {
    PartidoProvider partidoProvider = Provider.of<PartidoProvider>(context);
    TemaConfig tema = Provider.of<TemaProvider>(context).temaMarcador;
    
    return Scaffold(
      backgroundColor: Color(Utils.parseHex(tema.primaryColor)),
      body: Center(
        child: CircularProgressIndicator(),
      )
    );
  }
  
 
}