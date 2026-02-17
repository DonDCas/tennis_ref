/* import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenis_pot3/Utils/utils.dart';
import 'package:tenis_pot3/controller/appController.dart';
import 'package:tenis_pot3/models/jugador_model.dart';
import 'package:tenis_pot3/models/partido_model.dart';
import 'package:tenis_pot3/models/theme_config_model.dart';
import 'package:tenis_pot3/presentations/widget/puntuaciones_widget.dart';
import 'package:tenis_pot3/services/jugador_service.dart';
import 'package:tenis_pot3/services/partido_service.dart';
import 'package:tenis_pot3/services/theme_config_service.dart';

class PartidoScreen extends StatefulWidget {
  PartidoScreen({super.key});
  @override
  State<PartidoScreen> createState() => _PartidoScreenState();
}

class _PartidoScreenState extends State<PartidoScreen> {
  TemaConfig? tema;
  ThemeConfigService temaService = ThemeConfigService();
  PartidoService partidoService = PartidoService();
  JugadorService jugadorService = JugadorService();
  Partido? partido; 
  Jugador? jugador1;
  Jugador? jugador2;
  AppController appController = AppController();
  @override
  void initState() {
    super.initState();
    cargarTema();
    cargarPartido();
  }

  Future<void> cargarTema() async {
    final data = await temaService.getTema("Marcador");
    setState(() {
      tema = data;
    });
  }

  void cargarPartido() async{
    final data = await partidoService.getPrimerPartido();
    partido = data;
    jugador1 = await jugadorService.getJugador(partido!.equipo1.idJugador);
    jugador2 = await jugadorService.getJugador(partido!.equipo2.idJugador);
    await Future.delayed(Duration(seconds: 2));
    Random random = Random();
    int num = random.nextInt(100);
    if (num%2 == 0){
      partido!.equipo1.saque = true;
      partido!.equipo2.saque = false;
    } 
    else{
      partido!.equipo2.saque = true;
      partido!.equipo1.saque = false;
      };
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (tema == null) ? Colors.white : Color(Utils.parseHex(tema!.primaryColor)),      
      body: (jugador2 == null) ? Center(child: Image.asset("assets/gif/Tennis_Ball.gif"),) 
      : Placeholder()/* Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // TITULO DEL PARTIDO
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GlowText(
                        '${partido!.competicion}',
                        style: GoogleFonts.getFont(
                          tema!.fontFamily,
                          color: Color(Utils.parseHex(tema!.neonColor)),
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                        ),
                        glowColor: Color(Utils.parseHex(tema!.gridColor!)),
                      ),
                      Text(
                        '${partido!.fase}',
                        style: GoogleFonts.getFont(
                          tema!.fontFamily,
                          color: Color(Utils.parseHex(tema!.gridColor!)),
                          fontSize: 22,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox( 
              height: 10,),
            lineaDivisoria(tema: tema),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                AvatarJugador(tema: tema, saque: partido!.equipo1.saque!, jugador: jugador1!,),
                SizedBox(width: 30,),
                //Jugador 1
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text('${jugador1!.nombre}', 
                  style: GoogleFonts.getFont(
                    tema!.fontFamily,
                    color: Color(Utils.parseHex(tema!.textColor)),
                    fontSize: 20
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text('${jugador1!.nacionalidad}', 
                  style: GoogleFonts.getFont(
                    tema!.fontFamily,
                    color: Color(Utils.parseHex(tema!.buttonColor)),
                    fontSize: 15
                    ),
                  ),
                ],),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 8 - 20,
                ),
                Text("VS",
                style: GoogleFonts.getFont(
                  tema!.fontFamily,
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: Color(Utils.parseHex(tema!.neonColor)),
                  shadows: [
                    Shadow(
                      color: Color(Utils.parseHex(tema!.neonColor)),
                      blurRadius: 12,
                    ),
                    Shadow(
                      color: Color(Utils.parseHex(tema!.neonColor)),
                      blurRadius: 24,
                    ),
                  ],
                ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 8 - 20,
                ),
                //Jugador 2
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                  Text('${jugador2!.nombre}', 
                  style: GoogleFonts.getFont(
                    tema!.fontFamily,
                    color: Color(Utils.parseHex(tema!.textColor)),
                    fontSize: 20
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text('${jugador2!.nacionalidad}', 
                  style: GoogleFonts.getFont(
                    tema!.fontFamily,
                    color: Color(Utils.parseHex(tema!.buttonColor)),
                    fontSize: 15
                    ),
                  ),
                ],),
                SizedBox(width: 30,),
                AvatarJugador(tema: tema, saque: partido!.equipo2.saque!, jugador: jugador2!,)
              ],
            ),
           SizedBox(height: 80,),
           PuntuacionesWidget(tema!, partido!, jugador1!, jugador2!),
           SizedBox(height: MediaQuery.of(context).size.height / 6 -70 ,),
           lineaDivisoria(tema: tema),
           SizedBox(height: 20,),
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  appController.nuevoPunto(partido!, partido!.equipo1, partido!.equipo2);
                  setState(() {
                    if (partido!.ganador != null ) context.go("/finPartido");
                  });
                },
                child: Container(
                  width: 300,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(tema!.borderRadius.toDouble())),
                    color: Color(Utils.parseHex(tema!.neonColor)),
                    boxShadow: [ BoxShadow(
                      color: Color(Utils.parseHex(tema!.neonColor)),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Punto para ${jugador1!.nombre}'
                    ),
                  ),
                ),
              ),
              SizedBox(width: 30,),
              GestureDetector(
                onTap: (){
                  appController.nuevoPunto(partido!, partido!.equipo2, partido!.equipo1);
                  setState(() {
                    if (partido!.ganador != null ) context.go(
                      "/finPartido",
                      extra: partido,
                      );
                  });
                },
                child: Container(
                  width: 300,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(tema!.borderRadius.toDouble())),
                    color: Color(Utils.parseHex(tema!.neonColor)),
                    boxShadow: [ BoxShadow(
                      color: Color(Utils.parseHex(tema!.neonColor)),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Punto para ${jugador2!.nombre}'
                    ),
                  ),
                ),
              ),
              SizedBox(width: 30,),
              GestureDetector(
                onTap: () async {
                  if(await partidoService.guardarPartido(partido!)){
                    showDialog(
                      context: context, 
                      builder: (BuildContext context){
                        return AlertDialog(
                          title: Text("Partido Guardado"),
                          content: Text("¿Que deseas hacer?"),
                          actions: [
                            TextButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                              }, 
                              child: Text('Cerrar')
                            ),
                            TextButton(
                              onPressed: (){
                                context.go("/");
                              }, 
                              child: Text('Volver al menu de inicio.')
                            ),
                          ],
                        );
                      }
                    );
                  }
                  else{
                    showDialog(
                      context: context, 
                      builder: (BuildContext context){
                        return AlertDialog(
                          title: Text("No se pudo guardar el partido!"),
                          content: Text("¿Que deseas hacer?"),
                          actions: [
                            TextButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                              }, 
                              child: Text('Cerrar')
                            ),
                          ],
                        );
                      }
                    );
                  }
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(tema!.borderRadius.toDouble()-5)),
                      color: Color(Utils.parseHex(tema!.tableRowColor!)),
                      boxShadow: [ BoxShadow(
                        color: Color(Utils.parseHex(tema!.neonColor)),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),]
                    ),
                  child: Icon(
                    Icons.save_alt,
                    color: Color(Utils.parseHex(tema!.buttonColor)),
                    size: 30
                  )
                ),
              ),
            ],
           )
          ],
        ),
      ), */
    );
  } 
}

class lineaDivisoria extends StatelessWidget {
  const lineaDivisoria({
    super.key,
    required this.tema,
  });

  final TemaConfig? tema;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Container(
        height: 1,
        width: MediaQuery.of(context).size.width - 50,
        color: Color(Utils.parseHex(tema!.gridColor!))
      ),
    ],);
  }
}

class AvatarJugador extends StatelessWidget {
  const AvatarJugador({
    super.key,
    required this.jugador,
    required this.tema,
    required this.saque,
  });

  final TemaConfig? tema;
  final bool saque;
  final Jugador jugador;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Borde de la app
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: (saque) 
            ? [ BoxShadow(
                color: Color(Utils.parseHex(tema!.neonColor)),
                blurRadius: 20,
                spreadRadius: 2,
              ),]
            : null
          ),
        ),
        Container(
          //Foto Jugador
          child: ClipOval(
            child: Image.network(jugador.foto,
            fit: BoxFit.cover,
            alignment: Alignment(0, -0.6),
            ),
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: (saque) 
              ? Color(Utils.parseHex(tema!.neonColor))
              : Color (Utils.parseHex(tema!.gridColor!))
              ,
              width: 3,
            ),
          ),
          width: 100,
          height: 100,
        ),
        //Icono Saque
        Positioned(
          bottom: 4,
          right: 4,
          child: Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(
                (saque) 
                ? Utils.parseHex(tema!.neonColor)
                : Utils.parseHex(tema!.primaryColor))
            ),
            child: const Icon(
              Icons.sports_tennis,
              size: 16,
              color: Colors.black
            ),
          )
        ),
      ],
    );
  }
}

 */