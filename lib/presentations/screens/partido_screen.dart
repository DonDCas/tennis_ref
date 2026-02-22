import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tennis_ref/Utils/utils.dart';
import 'package:tennis_ref/models/jugador_model.dart';
import 'package:tennis_ref/models/partido_model.dart';
import 'package:tennis_ref/models/theme_config_model.dart';
import 'package:tennis_ref/presentations/widget/puntuaciones_widget.dart';
import 'package:tennis_ref/providers/jugador_provider.dart';
import 'package:tennis_ref/providers/partido_provider.dart';
import 'package:tennis_ref/providers/tema_provider.dart';


class PartidoScreen extends StatelessWidget{
  
  PartidoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //Cargamos Tema
    TemaConfig tema = Provider.of<TemaProvider>(context).temaMarcador;
    //Cargamos Providers
    PartidoProvider partidoProvider = Provider.of<PartidoProvider>(context);
    JugadorProvider jugadorProvider = Provider.of<JugadorProvider>(context);

    //Cargamos Objetos
    Partido partido = partidoProvider.partidoEnJuego!;
    Participante participante1 = partido.participantes  [0];
    Participante participante2 = partido.participantes[1];
    Jugador jugador1 = jugadorProvider.jugadorEnJuego1;
    Jugador jugador2 = jugadorProvider.jugadorEnJuego2;

    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Color(Utils.parseHex(tema.primaryColor)),      
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cabecera(partido: partido, tema: tema),
            SizedBox( 
              height: 10,),
            lineaDivisoria(size, tema),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: _InfoJugador(
                      align: CrossAxisAlignment.start,
                      jugador: jugador1, 
                      participante : participante1, 
                      tema:tema, 
                      size: size
                  ),
                ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 8 - 20,
              ),
              Text("VS",
              style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.bold,
                color: Color(Utils.parseHex(tema.neonColor)),
                shadows: [
                  Shadow(
                    color: Color(Utils.parseHex(tema.neonColor)),
                    blurRadius: 12,
                  ),
                  Shadow(
                    color: Color(Utils.parseHex(tema.neonColor)),
                    blurRadius: 24,
                  ),
                ],
              ),
              ),
              Expanded(
                child: _InfoJugador(
                  align: CrossAxisAlignment.end, 
                  tema: tema,
                  participante: participante2, 
                  jugador: jugador2, 
                  size: size),
                )
              ]
            ),
           SizedBox(height: 80,),
           PuntuacionesWidget(tema, partido, jugador1, jugador2, participante1, participante2),
           SizedBox(height: MediaQuery.of(context).size.height / 6 -70 ,),
           lineaDivisoria(size, tema),
           Spacer(),
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  partidoProvider.sumarPuntoAlGanador(participante1, participante2);
                  if (partido.ganador!.isNotEmpty) context.go('/finPartido');
                },
                child: Container(
                  width: 300,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(tema.borderRadius.toDouble())),
                    color: Color(Utils.parseHex(tema.neonColor)),
                    boxShadow: [ BoxShadow(
                      color: Color(Utils.parseHex(tema.neonColor)),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Punto para ${jugador1.nombreCompleto}',
                      style: TextStyle(
                        color: Colors.black
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 30,),
              GestureDetector(
                onTap: (){
                  partidoProvider.sumarPuntoAlGanador(participante2, participante1);
                  if (partido.ganador!.isNotEmpty){
                    context.go('/finPartido');
                  } 
                },
                child: Container(
                  width: 300,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(tema.borderRadius.toDouble())),
                    color: Color(Utils.parseHex(tema.neonColor)),
                    boxShadow: [ BoxShadow(
                      color: Color(Utils.parseHex(tema.neonColor)),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Punto para ${jugador2.nombreCompleto}',
                      style: TextStyle(
                        color: Colors.black
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 30,),
              GestureDetector(
                onTap: () async {
                  if(await partidoProvider.guardarPartido(partido)){
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
                                partidoProvider.deselecPartido(partido);
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
                      borderRadius: BorderRadius.all(Radius.circular(tema.borderRadius.toDouble()-5)),
                      color: Color(Utils.parseHex(tema.tableRowColor!)),
                      boxShadow: [ BoxShadow(
                        color: Color(Utils.parseHex(tema.neonColor)),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),]
                    ),
                  child: Icon(
                    Icons.save_alt,
                    color: Color(Utils.parseHex(tema.buttonColor)),
                    size: 30
                  )
                ),
              ),
            ],
           )
        ]
      )
    )
  );
}
  
  Widget _cabecera({required Partido partido, required TemaConfig tema}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // TITULO DEL PARTIDO
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlowText(
                partido.competicion,
                style: TextStyle(
                  color: Color(Utils.parseHex(tema.neonColor)),
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                ),
                glowColor: Color(Utils.parseHex(tema.gridColor!)),
              ),
              Text(
                Utils.conversorFase(partido.fase),
                style: TextStyle(
                  color: Color(Utils.parseHex(tema.gridColor!)),
                  fontSize: 22,
                ),
              )
            ],
          ),
        ),    
      ],
    );
  } 
  Widget lineaDivisoria(Size size, TemaConfig tema){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Container(
          height: 1,
          width: size.width - 50,
          color: Color(Utils.parseHex(tema.gridColor!))
        ),
      ],
    );
  }
}

class _InfoJugador extends StatelessWidget {

  final CrossAxisAlignment align;
  final TemaConfig tema;
  final Participante participante;
  final Jugador jugador;
  final Size size;

  _InfoJugador({
    required this.align,
    required this.tema,
    required this.participante,
    required this.jugador,
    required this.size
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: align,
      children: [
        AvatarJugador(tema: tema, saque: participante.saque,jugador: jugador),
        SizedBox (width: 30),
        Column(
          crossAxisAlignment: align,
          children: [
            Text(jugador.nombreCompleto, 
            style: TextStyle(
              color: Color(Utils.parseHex(tema.textColor)),
              fontSize: 20
              ),
            ),
            SizedBox(height: 10,),
            Text(jugador.pais, 
            style: TextStyle(
              color: Color(Utils.parseHex(tema.buttonColor)),
              fontSize: 15
            ),
          ),
          SizedBox(
            width: size.width / 8 - 20,
          ),
        ],
      )
    ]);
  }                
}

class AvatarJugador extends StatelessWidget {
  const AvatarJugador({
    super.key,
    required this.jugador,
    required this.tema,
    required this.saque,
  });

  final TemaConfig tema;
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
                color: Color(Utils.parseHex(tema.neonColor)),
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
              ? Color(Utils.parseHex(tema.neonColor))
              : Color (Utils.parseHex(tema.gridColor!))
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
                ? Utils.parseHex(tema.neonColor)
                : Utils.parseHex(tema.primaryColor))
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
