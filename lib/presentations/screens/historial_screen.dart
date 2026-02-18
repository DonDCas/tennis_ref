import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tennis_ref/Utils/utils.dart';
import 'package:tennis_ref/models/jugador_model.dart';
import 'package:tennis_ref/models/partido_model.dart';
import 'package:tennis_ref/models/theme_config_model.dart';
import 'package:tennis_ref/providers/partido_provider.dart';
import 'package:tennis_ref/providers/tema_provider.dart';
import 'package:tennis_ref/services/jugador_service.dart';
import 'package:tennis_ref/services/partido_service.dart';
import 'package:tennis_ref/services/theme_config_service.dart';

class HistorialSplash extends StatefulWidget {
  const HistorialSplash({super.key});

  @override
  State<HistorialSplash> createState() => _HistorialSplashState();
}

class _HistorialSplashState extends State<HistorialSplash> {
  @override
  Widget build(BuildContext context) {
    TemaConfig tema = Provider.of<TemaProvider>(context).temaMarcador;
    final partidoProvider = Provider.of<PartidoProvider>(context, listen: false);

    Future.microtask(() async {
      
      await partidoProvider.getAllPatidos();

      if (context.mounted) {
        context.pushReplacement('/historial'); 
      }
    });
    return Scaffold(
      backgroundColor: Color(Utils.parseHex(tema.primaryColor)),
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text("Recuperando partidos..."),
          ],
        ),
      )
    );
  }
}


class HistorialScreen extends StatelessWidget {
  const HistorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PartidoProvider partidoProvider = Provider.of<PartidoProvider>(context);
    List<Partido> partidos = partidoProvider.partidosHistorial;
    TemaConfig tema = Provider.of<TemaProvider>(context).temaMarcador;
    return Scaffold(
      backgroundColor: Color(Utils.parseHex(tema.primaryColor)),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Historial de Partidos',
                style: TextStyle(
                  color: Color(Utils.parseHex(tema.textColor)),
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                )),
                GestureDetector(
                  onTap: (){
                    context.go('/');
                  }, 
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(Utils.parseHex(tema.buttonColor)),
                      borderRadius: BorderRadius.all(Radius.circular(tema.borderRadius.toDouble()))
                    ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Text('< REGRESAR')
                  ),
                )
              ],
            ),
            SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(Utils.parseHex(tema.neonColor)),
                ),
                child: Row(
                  children: [
                    headerCell('Fecha', Color(Utils.parseHex(tema.buttonColor))),
                    headerCell('Foto',  Color(Utils.parseHex(tema.buttonColor))),
                    headerCell('Ganador',  Color(Utils.parseHex(tema.buttonColor))),
                    headerCell('Resultado', Color(Utils.parseHex(tema.buttonColor))),
                  ],
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: partidos.length,
                itemBuilder: (context, index) {
                  final partido = partidos[index];
                  
                  Jugador? ganador;
                  try {
                    ganador = Jugador.fromJson({
    "id": "0f3a8c21-4e6b-4b9a-8c1d-9e2a1b3c0001",
    "nombre_completo": "Carlos Alcaraz",
    "pais": "España",
    "bandera": "ES",
    "fecha_nacimiento": "2003-05-05",
    "ranking_atp": 2,
    "mejor_ranking": 1,
    "mano_dominante": "D",
    "foto": "https://api-tenis.duckdns.org/media/jugadores/default.png",
    "creacion": "2026-01-30T13:15:27.227324Z",
    "actualizacion": "2026-01-30T13:15:27.227330Z"
});
                  } catch (e) {
                    ganador = null;
                  }

                  if (ganador == null) {
                    return const SizedBox.shrink();
                  }

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(Utils.parseHex(tema.primaryColor)),
                      borderRadius: BorderRadius.circular(
                        tema.borderRadius.toDouble(),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          partido.fechaIniciado.toString(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        jugador(
                          ganador,
                          Color(Utils.parseHex(tema!.neonColor)),
                        ),
                        resultado(
                          ganador,
                          partido,
                          tema.fontFamily,
                          Color(Utils.parseHex(tema!.neonColor)),
                          0,
                        ),
                        const Text(' | '),
                        resultado(
                          ganador,
                          partido,
                          tema.fontFamily,
                          Color(Utils.parseHex(tema!.neonColor)),
                          1,
                        ),
                        const Text(' | '),
                        resultado(
                          ganador,
                          partido,
                          tema.fontFamily,
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
      ), 
    );
  }
}
Widget resultado(Jugador ganador, Partido partido, String fontFamily, Color color, int numSet) {
  return Text ((ganador.id == partido.participantes[0].id) 
    ? '${partido.participantes[0].sets1} - ${partido.participantes[1].sets1}'
    : '${partido.participantes[1].sets1} - ${partido.participantes[0].sets1}',
    style: TextStyle(
      color: color,
      fontSize: 30
    ),
  );
}

Widget jugador(Jugador ganador, Color color) {
  return  Container(
    child:Text(
      ganador.nombreCompleto,
      style: TextStyle(
        color: color,
        fontSize: 22
      ),
    ),
  );

}

Widget headerCell(String texto, Color color){
  return Expanded(
    flex: 2,
    child: Text(
      texto,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.bold
      ),
    )
  );
}

