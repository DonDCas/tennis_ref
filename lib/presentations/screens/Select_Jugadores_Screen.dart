import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tenis_pot3/Utils/utils.dart';
import 'package:tenis_pot3/models/jugador_model.dart';
import 'package:tenis_pot3/models/theme_config_model.dart';
import 'package:tenis_pot3/presentations/widget/crear_jugador_sheet.dart';
import 'package:tenis_pot3/providers/jugador_provider.dart';
import 'package:tenis_pot3/providers/tema_provider.dart';

class SelectJugadoresScreen extends StatefulWidget {
  const SelectJugadoresScreen({super.key});

  @override
  State<SelectJugadoresScreen> createState() => _SelectJugadoresScreenState();
}

class _SelectJugadoresScreenState extends State<SelectJugadoresScreen> {
  int jugador1Index = 0;
  int jugador2Index = 1;

  @override
  Widget build(BuildContext context) {
    final tema = Provider.of<TemaProvider>(context).temaMenu!;
    final jugadorProvider = Provider.of<JugadorProvider>(context);
    final jugadores = jugadorProvider.jugadores;

    // Lógica para determinar si mostrar un jugador o la tarjeta de "Añadir"
    Jugador? jugador1 = jugador1Index >= jugadores.length ? null : jugadores[jugador1Index];
    Jugador? jugador2 = jugador2Index >= jugadores.length ? null : jugadores[jugador2Index];

    return Scaffold(
      backgroundColor: Color(Utils.parseHex(tema.primaryColor)),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo-2.png", width: 150),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PlayerCard(
                    title: "Jugador 1",
                    jugador: jugador1,
                    // PASAMOS LA REFERENCIA (sin paréntesis)
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
                        color: Color(Utils.parseHex(tema.neonColor)),
                      ),
                    ),
                  ),
                  PlayerCard(
                    title: "Jugador 2",
                    jugador: jugador2,
                    onNext: nextJugador2,
                    onPrev: prevJugador2,
                    onAddPlayer: abrirCrearJugador2,
                    tema: tema,
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () => context.go('/menupartido'),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                decoration: BoxDecoration(
                  color: Color(Utils.parseHex(tema.neonColor)),
                  borderRadius: BorderRadius.circular(tema.borderRadius.toDouble())
                ),
                child: Text(
                  'Volver',
                  style: TextStyle(
                    color: Color(Utils.parseHex(tema.buttonColor))
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // MÉTODOS DE NAVEGACIÓN CORREGIDOS
  void nextJugador1() {
    final total = Provider.of<JugadorProvider>(context, listen: false).jugadores.length + 1;
    setState(() {
      jugador1Index = (jugador1Index + 1) % total;
      if (jugador1Index == (total - 5)) Provider.of<JugadorProvider>(context).getAllJugadores();
      if (jugador1Index == jugador2Index && jugador1Index < total - 1) nextJugador1();
    });
  }

  void prevJugador1() {
    final total = Provider.of<JugadorProvider>(context, listen: false).jugadores.length + 1;
    setState(() {
      jugador1Index = (jugador1Index - 1 + total) % total;
      if (jugador1Index == jugador2Index && jugador1Index < total - 1) prevJugador1();
    });
  }

  void nextJugador2() {
    final total = Provider.of<JugadorProvider>(context, listen: false).jugadores.length + 1;
    setState(() {
      jugador2Index = (jugador2Index + 1) % total;
      if (jugador2Index == (total - 5)) Provider.of<JugadorProvider>(context).getAllJugadores();
      if (jugador1Index == jugador2Index && jugador2Index < total - 1) nextJugador2();
    });
  }

  void prevJugador2() {
    final total = Provider.of<JugadorProvider>(context, listen: false).jugadores.length + 1;
    setState(() {
      jugador2Index = (jugador2Index - 1 + total) % total;
      if (jugador1Index == jugador2Index && jugador2Index < total - 1) prevJugador2();
    });
  }

  void abrirCrearJugador1() async {
    final nuevoJugador = await showModalBottomSheet<Jugador>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const CrearJugadorSheet(),
    );

    if (nuevoJugador != null) {
      setState(() {
        // El provider debería actualizar la lista automáticamente si el Sheet llama al service
        jugador1Index = Provider.of<JugadorProvider>(context, listen: false).jugadores.length - 1;
      });
    }
  }

  void abrirCrearJugador2() async {
    final nuevoJugador = await showModalBottomSheet<Jugador>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const CrearJugadorSheet(),
    );

    if (nuevoJugador != null) {
      setState(() {
        jugador2Index = Provider.of<JugadorProvider>(context, listen: false).jugadores.length - 1;
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
    required this.title,
    required this.jugador,
    required this.onNext,
    required this.onPrev,
    required this.onAddPlayer,
    required this.tema,
  });

  @override
  Widget build(BuildContext context) {
    // Si no hay jugador en ese índice, mostramos la tarjeta de añadir
    if (jugador == null) {
      return _addPlayerCard();
    }

    return Container(
      width: 350,
      height: 400, // Ajustado para que quepa el ranking
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(Utils.parseHex(tema.buttonColor)),
        borderRadius: BorderRadius.circular(tema.borderRadius.toDouble()),
        border: Border.all(color: Color(Utils.parseHex(tema.neonColor))),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.getFont(tema.fontFamily, color: Color(Utils.parseHex(tema.neonColor))),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundImage: NetworkImage(jugador!.foto),
                ),
                Positioned(
                  left: 0,
                  child: IconButton(
                    iconSize: 50,
                    onPressed: onPrev,
                    icon: Icon(Icons.chevron_left, color: Color(Utils.parseHex(tema.neonColor))),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    iconSize: 50,
                    onPressed: onNext,
                    icon: Icon(Icons.chevron_right, color: Color(Utils.parseHex(tema.neonColor))),
                  ),
                ),
              ],
            ),
          ),
          Text(
            jugador!.nombreCompleto,
            textAlign: TextAlign.center,
            style: GoogleFonts.getFont(tema.fontFamily, fontSize: 20, color: Color(Utils.parseHex(tema.neonColor))),
          ),
          const SizedBox(height: 8),
          Text(
            'RANKING ${jugador!.rankingAtp}',
            style: GoogleFonts.getFont(tema.fontFamily, color: Color(Utils.parseHex(tema.neonColor))),
          ),
        ],
      ),
    );
  }

  Widget _addPlayerCard() {
    return GestureDetector(
      onTap: onAddPlayer,
      child: Container(
        width: 350,
        height: 400,
        decoration: BoxDecoration(
          color: Color(Utils.parseHex(tema.buttonColor)),
          borderRadius: BorderRadius.circular(tema.borderRadius.toDouble()),
          border: Border.all(color: Color(Utils.parseHex(tema.neonColor))),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, size: 80, color: Color(Utils.parseHex(tema.neonColor))),
            const SizedBox(height: 16),
            Text(
              "ADD PLAYER",
              style: GoogleFonts.getFont(tema.fontFamily, color: Color(Utils.parseHex(tema.neonColor))),
            ),
          ],
        ),
      ),
    );
  }
}