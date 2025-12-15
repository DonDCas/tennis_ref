import 'package:tenis_pot3/Utils/utils.dart';
import 'package:tenis_pot3/models/partido_model.dart';
import 'package:tenis_pot3/services/partido_service.dart';

class AppController {
  

  String conversor(int puntos) {
    return switch(puntos){
      0 => "0",
      1 => "15",
      2 => "30",
      3 => "40",
      4 => "Av",
      5 => "60",
      _ => "ERROR"
    };
  }


  void nuevoPunto(Partido partido, JugadorStats ganador, JugadorStats perdedor) {
    ganador.puntos++;

    if (partido.isTieBreak!) {
      tiebreak(partido, ganador, perdedor);
      return;
    }

    bool ventaja = (ganador.puntos - perdedor.puntos) >= 2;

    if (ganador.puntos >= 4) {
      if (perdedor.puntos == 4) {
        ganador.puntos = 3;
        perdedor.puntos = 3; 
      } else if (ventaja) {
        ganador.puntos = perdedor.puntos = 0;
        actualizarJuegos(partido, ganador, perdedor);
      }
    }
  }


  void actualizarJuegos(Partido partido, JugadorStats ganador, JugadorStats perdedor) {  
    ganador.saque = !ganador.saque!;
    perdedor.saque = !perdedor.saque!;
    ganador.juegos++;
    int setActual = (ganador.sets + perdedor.sets);

    if (ganador.idJugador == partido.equipo1.idJugador) partido.sets_e1[setActual] ++;
    if (ganador.idJugador == partido.equipo2.idJugador) partido.sets_e2[setActual] ++;

    if (ganador.juegos == 6 && perdedor.juegos == 6) {
      partido.isTieBreak = true;
      return;
    }

    bool ventaja = (ganador.juegos - perdedor.juegos) >= 2;

    if (ganador.juegos >= 6 && ventaja) {
      ganador.sets++;
      ganador.juegos = perdedor.juegos = 0;
    }

    if (ganador.sets == 2){
        partido.ganador = ganador.idJugador;
        partido.fechaJugado = DateTime.now().toString();
        PartidoService partidoService = PartidoService();
        partidoService.guardarPartido(partido);
      } 
  }

  void tiebreak(Partido partido, JugadorStats ganador, JugadorStats perdedor) {
    int totalpuntos = ganador.puntos! + perdedor.puntos!;

    if(totalpuntos > 1 && (totalpuntos%2 != 0)){
      ganador.saque = !ganador.saque!;
      perdedor.saque = !perdedor.saque!;
    }
    if (ganador.puntos >= 7 && (ganador.puntos - perdedor.puntos) >= 2) {
      int setActual = (ganador.sets + perdedor.sets);
      if (ganador.idJugador == partido.equipo1.idJugador) {
        partido.sets_e1[setActual] ++;
        partido.sets_e2[setActual] --;
      }
      if (ganador.idJugador == partido.equipo2.idJugador){
        partido.sets_e1[setActual] --;
        partido.sets_e2[setActual] ++;
      }
      ganador.sets++;
      partido.isTieBreak = false;
      ganador.puntos = perdedor.puntos = 0;
      ganador.juegos = perdedor.juegos = 0; 
      if (ganador.sets == 2){
        partido.ganador = ganador.idJugador;
        partido.fechaJugado =DateTime.now().toString();
        PartidoService partidoService = PartidoService();
        partidoService.guardarPartido(partido);
      } 
    }
  }
}