import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenis_pot3/Utils/utils.dart';
import 'package:tenis_pot3/models/jugador_model.dart';
import 'package:tenis_pot3/models/partido_model.dart';
import 'package:tenis_pot3/models/theme_config_model.dart';
import 'package:tenis_pot3/services/jugador_service.dart';
import 'package:tenis_pot3/services/partido_service.dart';
import 'package:tenis_pot3/services/theme_config_service.dart';

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  TemaConfig? tema;
  final ThemeConfigService themeConfigService = ThemeConfigService();
  final PartidoService partidoService = PartidoService();
  late List<Partido> partidosAcabados = [];
  final JugadorService jugadorService = JugadorService();
  late List<Jugador> jugadores = [];
  @override
  void initState() {
    super.initState();
    cargarDatos();
  }
  void cargarDatos() async {
    final data = await themeConfigService.getTema("Marcador");
    final dataPartidos = await partidoService.getPartidos();
    final dataJugadores = await jugadorService.getJugadores();
    
    final List<Partido> partidosTemp = [];
    final List<Jugador> jugadoresTemp = [];
    for (final partido in dataPartidos) {
      if (partido?.ganador != null) {
        partidosTemp.add(partido!);
      }
    }
    for(final jugador in dataJugadores){
      jugadoresTemp.add(jugador!);
    }
    setState(() {
      tema = data;
      partidosAcabados = partidosTemp;
      jugadores = jugadoresTemp;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (tema == null) return Scaffold( body: Center(child:Center(child: Image.asset("assets/gif/Tennis_Ball.gif"),)),);
    return Scaffold(
      backgroundColor: (tema == null) ? Colors.white : Color(Utils.parseHex(tema!.primaryColor)),
      body: Placeholder() /* Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Historial de Partidos',
                style: GoogleFonts.getFont(
                  tema!.fontFamily,
                  color: Color(Utils.parseHex(tema!.textColor)),
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                )),
                GestureDetector(
                  onTap: (){
                    context.go('/');
                  }, 
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(Utils.parseHex(tema!.buttonColor)),
                      borderRadius: BorderRadius.all(Radius.circular(tema!.borderRadius.toDouble()))
                    ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Text('< REGRESAR',
                  style: GoogleFonts.getFont(
                      tema!.fontFamily,
                  )
                    )
                  ),
                )
              ],
            ),
            SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(Utils.parseHex(tema!.neonColor)),
                borderRadius: BorderRadius.all(Radius.circular(tema!.borderRadius.toDouble())),
                ),
                child: Row(
                  children: [
                    headerCell('Fecha', Color(Utils.parseHex(tema!.buttonColor)), tema!.fontFamily),
                    headerCell('Foto',  Color(Utils.parseHex(tema!.buttonColor)), tema!.fontFamily),
                    headerCell('Ganador',  Color(Utils.parseHex(tema!.buttonColor)), tema!.fontFamily),
                    headerCell('Resultado', Color(Utils.parseHex(tema!.buttonColor)), tema!.fontFamily),
                  ],
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: partidosAcabados.length,
                itemBuilder: (context, index) {
                  final partido = partidosAcabados[index];

                  Jugador? ganador;
                  try {
                    ganador = jugadores.firstWhere((j) => j.idJugador == partido.ganador);
                  } catch (e) {
                    ganador = null;
                  }

                  if (ganador == null) {
                    return const SizedBox.shrink();
                  }

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(Utils.parseHex(tema!.primaryColor)),
                      borderRadius: BorderRadius.circular(
                        tema!.borderRadius.toDouble(),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          partido.fechaJugado ?? ' - ',
                          style: GoogleFonts.getFont(
                            tema!.fontFamily,
                            color: Colors.white,
                          ),
                        ),
                        jugador(
                          ganador,
                          tema!.fontFamily,
                          Color(Utils.parseHex(tema!.neonColor)),
                        ),
                        resultado(
                          ganador,
                          partido,
                          tema!.fontFamily,
                          Color(Utils.parseHex(tema!.neonColor)),
                          0,
                        ),
                        const Text(' | '),
                        resultado(
                          ganador,
                          partido,
                          tema!.fontFamily,
                          Color(Utils.parseHex(tema!.neonColor)),
                          1,
                        ),
                        const Text(' | '),
                        resultado(
                          ganador,
                          partido,
                          tema!.fontFamily,
                          Color(Utils.parseHex(tema!.neonColor)),
                          2,
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ), */
    );
  }
}
/* 
Widget resultado(Jugador ganador, Partido partido, String fontFamily, Color color, int numSet) {
  return Text ((ganador.idJugador == partido.equipo1.idJugador) 
    ? '${partido.sets_e1[numSet]} - ${partido.sets_e2[numSet]}'
    : '${partido.sets_e2[numSet]} - ${partido.sets_e1[numSet]}',
    style: GoogleFonts.getFont(
      fontFamily,
      color: color,
      fontSize: 30
    ),
  );
}

Widget jugador(Jugador ganador, String fontFamily, Color color) {
  return  Container(
    child:Text(
      ganador!.nombre,
      style: GoogleFonts.getFont(
        fontFamily,
        color: color,
        fontSize: 22
      ),
    ),
  );

}

Widget headerCell(String texto, Color color, String fontFamily ){
  return Expanded(
    flex: 2,
    child: Text(
      texto,
      style: GoogleFonts.getFont(
        fontFamily,
        color: color,
        fontWeight: FontWeight.bold
      ),
    )
  );
} */