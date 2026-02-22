import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tennis_ref/Utils/utils.dart';
import 'package:tennis_ref/controller/appController.dart';
import 'package:tennis_ref/models/jugador_model.dart';
import 'package:tennis_ref/models/partido_model.dart';
import 'package:tennis_ref/models/theme_config_model.dart';

class PuntuacionesWidget extends StatelessWidget {

  final TemaConfig tema;
  final Partido partido;
  final Jugador jugador1;
  final Jugador jugador2;
  final Participante parti1;
  final Participante parti2;
  

  PuntuacionesWidget(this.tema, this.partido, this.jugador1, this.jugador2, this.parti1, this.parti2, {super.key});

  final AppController appController = AppController();

  List<int> get puntacionesJugador1 => [parti1.sets1, parti1.sets2, parti1.sets3];
  List<int> get puntacionesJugador2 => [parti2.sets1, parti2.sets2, parti2.sets3];

  @override
  Widget build(BuildContext context) {
    return Center(
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width -70 , // ancho de la tabla
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(Utils.parseHex(tema.tableRowColor!)),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Color(Utils.parseHex(tema.neonColor)),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(Utils.parseHex(tema.primaryColor)),
              blurRadius: 12,
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Cabecera(tema),
            const SizedBox(height: 6),
            _divisor(tema, context),
            _Fila(
              tema, '${jugador1.nombreCompleto}', 
              puntacionesJugador1, 
              (partido.isTieBreak)
                ? parti1.puntos.toString() 
                : appController.conversor(parti1.puntos
                )
              ),
            _Fila(
              tema, "${jugador2.nombreCompleto}", 
              puntacionesJugador2, 
              (partido.isTieBreak)
                ? parti2.puntos.toString() 
                :appController.conversor(parti2.puntos)),
          ],
        ),
      ),
    ),
  );
  }
}

class _Cabecera extends StatelessWidget {

  final TemaConfig tema;

  _Cabecera(this.tema, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _celda("Player", tema, flex: 3, isHeader: true, alignLeft: true),
        _celda("S1", tema, flex:1, isHeader: true ),
        _celda("S2", tema, flex:1, isHeader: true ),
        _celda("S3", tema, flex:1, isHeader: true ),
        _celda("GAME", tema, flex:2, isHeader: true ),
      ],
    );
  }
}

class _Fila extends StatelessWidget {

 final TemaConfig tema;
 final String nombre;
 final List<int> puntosJuegos;
 final String puntuacion;

  _Fila(this.tema, this.nombre, this.puntosJuegos, this.puntuacion, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _celda(nombre, tema, flex:3, alignLeft: true,),
        _celda(puntosJuegos[0].toString(), tema, flex:1, glow: true,),
        _celda(puntosJuegos[1].toString(), tema,  flex:1, glow: true,),
        _celda(puntosJuegos[2].toString(), tema, flex:1, glow: true,),
        _celdaFuerte(puntuacion, tema),
      ],
    );
  }
}

Widget _celda(
  String text,
  TemaConfig tema,{
  int flex = 1,
  bool isHeader = false,
  bool glow = false,
  bool alignLeft = false,
}) {
  return Expanded(
    flex: flex,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Align(
        alignment:
            alignLeft ? Alignment.centerLeft : Alignment.center,
        child: glow
          ? GlowText(
            text,
            style: TextStyle(
              color: Color(Utils.parseHex(tema.textColor)),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            glowColor: Colors.white,
            blurRadius: 8,
            )
          : Text(
            text,
            style: TextStyle(
              color: isHeader ? Color(Utils.parseHex(tema.gridColor!)) : Colors.white,
              fontSize: isHeader ? 14 : 18,
              fontWeight: isHeader ? FontWeight.w500 : FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}


Widget _celdaFuerte(
  String texto,
  TemaConfig tema) {
  return Expanded(
    flex: 2,
    child: GlowText(
      texto,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(Utils.parseHex(tema.neonColor)),
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      glowColor: Color(Utils.parseHex(tema.neonColor)),
      blurRadius: 20,
    )
  );
}

Widget _divisor(TemaConfig tema, BuildContext context){
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 1,
    color: Color(Utils.parseHex(tema.gridColor!)),
  );
}