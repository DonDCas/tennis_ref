import 'dart:math';

import 'package:tennis_ref/models/partido_model.dart';

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

  int getJuegosSetActual(Participante p, int numeroSet) {
    if (numeroSet == 0) return p.sets1;
    if (numeroSet == 1) return p.sets2;
    return p.sets3;
  }

  void sumarJuegoSetActual(Participante p, int numeroSet) {
    if (numeroSet == 0) p.sets1++;
    else if (numeroSet == 1) p.sets2++;
    else p.sets3++;
  }

  int calcularSetsGanados(Participante p, Participante rival) {
  int sets = 0;
  // Set 1
  if (p.sets1 >= 6 && (p.sets1 - rival.sets1) >= 2 || (p.sets1 == 7 && rival.sets1 == 6)) sets++;
  // Set 2
  if (p.sets2 >= 6 && (p.sets2 - rival.sets2) >= 2 || (p.sets2 == 7 && rival.sets2 == 6)) sets++;
  // Set 3 
  if (p.sets3 >= 6 && (p.sets3 - rival.sets3) >= 2 || (p.sets3 == 7 && rival.sets3 == 6)) sets++;

  return sets;
}


  void nuevoPunto(Partido partido, Participante ganador, Participante perdedor) {
    ganador.puntos++;

    if (partido.isTieBreak) {
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


  void actualizarJuegos(Partido partido, Participante ganador, Participante perdedor) {  
    ganador.saque = !ganador.saque;
    perdedor.saque = !perdedor.saque;

    int setsGanadosGanador = calcularSetsGanados(ganador, perdedor);
    int setsGanadosPerdedor = calcularSetsGanados(perdedor, ganador );
    
    int setActualIndice = setsGanadosPerdedor + setsGanadosGanador;
    sumarJuegoSetActual(ganador, setActualIndice);

    if (getJuegosSetActual(ganador, setActualIndice) == 6 && 
      getJuegosSetActual(perdedor, setActualIndice) == 6) {
      partido.isTieBreak = true;
      return;
    }

    int juegosG = getJuegosSetActual(ganador, setActualIndice);
    int juegosP = getJuegosSetActual(perdedor, setActualIndice);
    bool ventajaJuegos = (juegosG - juegosP) >= 2;
    
    if (juegosG >= 6 && ventajaJuegos) ganador.puntos = perdedor.puntos = 0;

    if (calcularSetsGanados(ganador, perdedor) == 2) {
       partido.ganador = ganador.jugador;
       partido.fechaFinalizado = DateTime.now().toIso8601String();
    }
  }

 void tiebreak(Partido partido, Participante ganador, Participante perdedor) {
    int totalpuntos = ganador.puntos + perdedor.puntos;

    if (totalpuntos > 0 && (totalpuntos % 2 != 0)) {
      ganador.saque = !ganador.saque;
      perdedor.saque = !perdedor.saque;
    }

    if (ganador.puntos >= 7 && (ganador.puntos - perdedor.puntos) >= 2) {
      int setsGanadosGanador = calcularSetsGanados(ganador, perdedor);
      int setsGanadosPerdedor = calcularSetsGanados(perdedor, ganador);
      int setActualIndice = setsGanadosGanador + setsGanadosPerdedor;

      sumarJuegoSetActual(ganador, setActualIndice);
      partido.isTieBreak = false;
      ganador.puntos = perdedor.puntos = 0;

      if (calcularSetsGanados(ganador, perdedor) == 2) {
        partido.ganador = ganador.jugador;
        partido.fechaFinalizado = DateTime.now().toIso8601String();
      }
    }
  }

  void eligeSaque(Partido? partidoEnJuego) {
    partidoEnJuego!.participantes[Random().nextInt(10)%2].saque = true;
  }
} 