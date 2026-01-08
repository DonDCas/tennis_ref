import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenis_pot3/Utils/utils.dart';
import 'package:tenis_pot3/models/jugador_model.dart';
import 'package:tenis_pot3/models/theme_config_model.dart';
import 'package:tenis_pot3/presentations/widget/crear_jugador_sheet.dart';

class SelectJugadoresScreen extends StatefulWidget {
  late TemaConfig temaConfig;
  late List<Jugador> jugadores;
  SelectJugadoresScreen({super.key, required this.temaConfig, required this.jugadores});

  @override
  State<SelectJugadoresScreen> createState() => _SelectJugadoresScreenState();
}

class _SelectJugadoresScreenState extends State<SelectJugadoresScreen> {
  int jugador1Index = 0;
  int jugador2Index = 1;
  int get totalSlots => widget.jugadores.length +1;
  
  @override
  Widget build(BuildContext context) {
    TemaConfig tema = widget.temaConfig;
    List<Jugador> jugadores = widget.jugadores;
    Jugador? jugador1 = jugador1Index == jugadores.length
      ? null
      : jugadores[jugador1Index];

    Jugador? jugador2 = jugador2Index == jugadores.length
      ? null
      : jugadores[jugador2Index];

    return Scaffold(
      backgroundColor: Color(Utils.parseHex(tema.primaryColor)),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo-2.png",
              width: 150, 
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PlayerCard(
                    title: "Jugador 1",
                    jugador: jugador1,
                    onNext: nextJugador1,
                    onPrev: prevJugador1,
                    onAddPlayer: abrirCrearJugador1,
                    tema: tema,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      "VS",
                      style: GoogleFonts.getFont(
                        tema.fontFamily,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(Utils.parseHex(tema.neonColor))
                      ),
                    ),
                  ),
                  PlayerCard(
                    title: "Jugador 2",
                    jugador: jugador2,
                    onNext: nextJugador2,
                    onPrev: prevJugador2,
                    onAddPlayer: abrirCrearJugador2,
                    tema: tema
                  ),
                  //PlayerCard()
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
  void nextJugador1() {
    setState(() {
      jugador1Index = (jugador1Index + 1) % (widget.jugadores.length + 1);
      if (jugador1Index == jugador2Index) nextJugador1();
    });
  }

  void prevJugador1() {
    setState(() {
      jugador1Index =
          (jugador1Index - 1 + widget.jugadores.length + 1) %
          (widget.jugadores.length + 1);
      if (jugador1Index == jugador2Index) prevJugador1();
    });
  }

  void nextJugador2() {
  setState(() {
    jugador2Index = (jugador2Index + 1) % (widget.jugadores.length + 1);
    if (jugador1Index == jugador2Index) nextJugador2();
  });
}

  void prevJugador2() {
    setState(() {
      jugador2Index =
          (jugador2Index - 1 + widget.jugadores.length + 1) %
          (widget.jugadores.length + 1);
      if (jugador1Index == jugador2Index) prevJugador2();
    });
  }

  void abrirCrearJugador1() async{
    final nuevoJugador = await showModalBottomSheet<Jugador>(
      context: context,
      isScrollControlled: true,
      builder: (_) => CrearJugadorSheet(),
    );

    if (nuevoJugador != null){
      setState(() {
        widget.jugadores.add(nuevoJugador);
        jugador1Index = widget.jugadores.length - 1;
      });
    }
  }

  void abrirCrearJugador2() async{
    final nuevoJugador = await showModalBottomSheet<Jugador>(
      context: context,
      isScrollControlled: true,
      builder: (_) => CrearJugadorSheet(),
    );

    if (nuevoJugador != null){
      setState(() {
        widget.jugadores.add(nuevoJugador);
        jugador2Index = widget.jugadores.length - 1;
      });
    }
  }
  
}

class PlayerCard extends StatelessWidget {
  final String title;
  final Jugador? jugador;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final VoidCallback onAddPlayer;
  final TemaConfig tema;
  const PlayerCard({
    super.key, 
    required String this.title, 
    required Jugador? this.jugador, 
    required void Function() this.onNext, 
    required void Function() this.onPrev, 
    required void Function() this.onAddPlayer,
    required TemaConfig this.tema, 
  });

  @override
  Widget build(BuildContext context) {
    if (jugador == null) {
      return _addPlayerCard();
    }
    return Container(
      width: 350,
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(Utils.parseHex(tema.buttonColor)),
        borderRadius: BorderRadius.circular(tema.borderRadius.toDouble()),
        border: Border.all(color: Colors.cyanAccent),
      ),
      child: Column(
        children: [
          Text(
            title, 
            style: GoogleFonts.getFont(
              tema.fontFamily,
              color: Color(Utils.parseHex(tema.neonColor)),
            ),
          ),
          SizedBox(height: 10),
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(jugador!.foto),
              ),
              Positioned(
                left: 0,
                child: IconButton(
                  iconSize: 70,
                  onPressed: onPrev,
                  icon: Icon(
                    Icons.chevron_left,
                    color: Color(Utils.parseHex(tema.neonColor))
                  )
                )
              ),
              Positioned(
                right: 0,
                child: IconButton(
                  iconSize: 70,
                  onPressed: onNext,
                  icon: Icon(
                    Icons.chevron_right,
                    color: Color(Utils.parseHex(tema.neonColor))
                  )
                )
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            '${jugador!.nombreCompleto}',
            textAlign: TextAlign.center,
            style: GoogleFonts.getFont(
              tema.fontFamily,
              fontSize: 20,
              color: Color(Utils.parseHex(tema.neonColor))
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            'RANKING ${jugador!.rankingAtp}',
            style: GoogleFonts.getFont(
              tema.fontFamily,
              color: Color(Utils.parseHex(tema.neonColor))
            ),
          )
        ],
      ),
    );
  }
  
  Widget _addPlayerCard() {
    return GestureDetector(
      onTap: onAddPlayer,
      child: Container(
        width: 350,
        height: 300,
        decoration:BoxDecoration(
          color: Color(Utils.parseHex(tema.buttonColor)),
          borderRadius: BorderRadius.circular(tema.borderRadius.toDouble()),
          border: Border.all(color: Colors.cyanAccent)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              size: 80,
              color: Color(Utils.parseHex(tema.neonColor)),
            ),
            SizedBox(height: 16,),
            Text(
              "ADD PLAYER",
              style: GoogleFonts.getFont(
                tema.fontFamily,
                color: Color(Utils.parseHex(tema.neonColor)),
              ),
            ),
          ],
        ),
      )
    );
  }
} 

