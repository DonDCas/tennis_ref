import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenis_pot3/Utils/utils.dart';
import 'package:tenis_pot3/models/jugador_model.dart';
import 'package:tenis_pot3/models/partido_model.dart';
import 'package:tenis_pot3/models/theme_config_model.dart';
import 'package:tenis_pot3/services/jugador_service.dart';
import 'package:tenis_pot3/services/theme_config_service.dart';

class FinalPartido extends StatefulWidget {
  final Partido partido;

  const FinalPartido({super.key, required this.partido});

  @override
  State<FinalPartido> createState() => _FinalPartidoState();
}

class _FinalPartidoState extends State<FinalPartido> {
  TemaConfig? tema;
  ThemeConfigService temaService = ThemeConfigService();
  JugadorService jugadorService = JugadorService();
  Jugador? ganador;
  Jugador? perdedor;
  @override
  void initState() {
    super.initState();
    cargarTema();
    cargarJugadores(widget.partido);
  }

  Future<void> cargarTema() async {
    final data = await temaService.getTema("Marcador");
    setState(() {
      tema = data;
    });
  }

  void cargarJugadores(Partido partido) async{
    if (partido.ganador == null) return;

    final g = await jugadorService.getJugador(partido.ganador);
    if (g == null) return;
    final p = (g.idJugador == partido.equipo1.idJugador)
      ? await jugadorService.getJugador(partido.equipo2.idJugador)
      : await jugadorService.getJugador(partido.equipo1.idJugador);

    setState(() {
      ganador = g;
      perdedor = p;
    });
  }
  @override
  Widget build(BuildContext context) {
    Partido partido = widget.partido;
    if (ganador == null || perdedor == null) return Scaffold (body: Center(child: Image.asset("assets/gif/Tennis_Ball.gif"),),);
    return Scaffold(
      backgroundColor: (tema == null) ? Colors.white : Color(Utils.parseHex(tema!.primaryColor)),      
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10,),
              Text(' PARTIDO FINALIZADO ',
              style: GoogleFonts.getFont(
                tema!.fontFamily,
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Color(Utils.parseHex(tema!.textColor)),
                )
              ),
              SizedBox(height: 30,),
              Container(
                width: MediaQuery.of(context).size.width - 250,
                height: 200,
                decoration: BoxDecoration(
                  color: Color(Utils.parseHex(tema!.tableRowColor.toString())),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                  BoxShadow(
                    blurRadius: 12,
                    color:Color(Utils.parseHex(tema!.neonColor))),
                  BoxShadow(
                    blurRadius: 21,
                    color:Color(Utils.parseHex(tema!.neonColor))),
                  ]
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AvatarJugador(jugador: ganador!, tema: tema),
                          ],
                        ),
                        SizedBox(width: 20,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ganador!.nombre,
                            style: GoogleFonts.getFont(
                              tema!.fontFamily,
                              color: Color(Utils.parseHex(tema!.textColor)),
                              fontSize: 30,
                            ),),
                            SizedBox(height: 10,),
                            Text(ganador!.nacionalidad,
                            style: GoogleFonts.getFont(
                              tema!.fontFamily,
                              color: Color(Utils.parseHex(tema!.neonColor)),
                              fontSize: 18,
                            ),
                        ),
                      ],
                    ),
                    SizedBox(width: 150,),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Resultado",
                              style: GoogleFonts.getFont(
                                tema!.fontFamily,
                                color: Color(Utils.parseHex(tema!.neonColor)),
                                fontSize: 18,
                              ),
                            ),
                            Row(
                              children: [
                                _Resultado(tema: tema!, partido: partido, ganador: ganador!, perdedor: perdedor!,numSet:  0),
                                Text('|',
                                    style: GoogleFonts.getFont(
                                      tema!.fontFamily,
                                      color: Color(Utils.parseHex(tema!.neonColor)),
                                      fontSize: 30
                                    )),
                                _Resultado(tema: tema!, partido: partido, ganador: ganador!, perdedor: perdedor!,numSet:  1),
                                Text('|',
                                    style: GoogleFonts.getFont(
                                      tema!.fontFamily,
                                      color: Color(Utils.parseHex(tema!.neonColor)),
                                      fontSize: 30
                                    )),
                                _Resultado(tema: tema!, partido: partido, ganador: ganador!, perdedor: perdedor!,numSet:  2),
                            ]),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 40,),
              Text(perdedor!.nombre,
              style: GoogleFonts.getFont(
                tema!.fontFamily,
                color: Colors.white
              )
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ResultadoPerdedor(tema: tema!, partido: partido, ganador: ganador!, perdedor: perdedor!,numSet:  0),
                  Text(' | ',
                      style: GoogleFonts.getFont(
                        tema!.fontFamily,
                        color: Color(Utils.parseHex(tema!.textColor) - 100),
                        fontSize: 15
                      ),),
                  _ResultadoPerdedor(tema: tema!, partido: partido, ganador: ganador!, perdedor: perdedor!,numSet:  1),
                  Text(' | ',
                      style: GoogleFonts.getFont(
                        tema!.fontFamily,
                        color: Color(Utils.parseHex(tema!.textColor) - 100),
                        fontSize: 15
                      ),),
                  _ResultadoPerdedor(tema: tema!, partido: partido, ganador: ganador!, perdedor: perdedor!,numSet:  2),
              ]),
              SizedBox(height: 50,),
              GestureDetector(
                onTap: () => context.go("/"),
                child: Container(
                  width: 300,
                  height: 75,
                  decoration: BoxDecoration(
                    color: Color(Utils.parseHex(tema!.neonColor)),
                    borderRadius: BorderRadius.all(Radius.circular(tema!.borderRadius.toDouble())),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('Volver \nal menu inicial.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.getFont(
                      tema!.fontFamily,
                      color: Color(Utils.parseHex(tema!.primaryColor)),
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                      
                    ),),
                  ),
                ),
              ),
            ],
          ),
        ),
      ) 
    );
  }
}

class AvatarJugador extends StatelessWidget {
  const AvatarJugador({
    super.key,
    required this.jugador,
    required this.tema,
  });

  final TemaConfig? tema;
  final Jugador jugador;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Borde de la app
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
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
              color: Color(Utils.parseHex(tema!.neonColor)),
              width: 3,
            ),
          ),
          width: 100,
          height: 100,
        ),
      ],
    );
  }
}


class _Resultado extends StatelessWidget {
  final TemaConfig tema;
  final Partido partido;
  final Jugador ganador;
  final Jugador perdedor;
  final int numSet;
  const _Resultado(
    {super.key, required this.tema, required this.partido, 
    required this.ganador, required this.perdedor, required this.numSet});

  @override
  Widget build(BuildContext context) {
    return Text ((ganador.idJugador == partido.equipo1.idJugador) 
    ? '${partido.sets_e1[numSet]} - ${partido.sets_e2[numSet]}'
    : '${partido.sets_e2[numSet]} - ${partido.sets_e1[numSet]}',
    style: GoogleFonts.getFont(
      tema.fontFamily,
      color: Color(Utils.parseHex(tema.neonColor)),
      fontSize: 30
    ),);
  }
}

class _ResultadoPerdedor extends StatelessWidget {
  final TemaConfig tema;
  final Partido partido;
  final Jugador ganador;
  final Jugador perdedor;
  final int numSet;
  const _ResultadoPerdedor(
    {super.key, required this.tema, required this.partido, 
    required this.ganador, required this.perdedor, required this.numSet});

  @override
  Widget build(BuildContext context) {
    return Text ((ganador.idJugador == partido.equipo1.idJugador) 
    ? '${partido.sets_e1[numSet]} - ${partido.sets_e2[numSet]}'
    : '${partido.sets_e2[numSet]} - ${partido.sets_e1[numSet]}',
    style: GoogleFonts.getFont(
      tema.fontFamily,
      color: Color(Utils.parseHex(tema.textColor) - 100),
      fontSize: 15
    ),);
  }
}