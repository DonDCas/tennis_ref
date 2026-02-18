import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tennis_ref/Utils/utils.dart';
import 'package:tennis_ref/models/jugador_model.dart';
import 'package:tennis_ref/presentations/widget/crear_jugador_sheet.dart';
import 'package:tennis_ref/presentations/widget/player_card.dart';
import 'package:tennis_ref/providers/jugador_provider.dart';
import 'package:tennis_ref/providers/tema_provider.dart';

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
                    rival: jugador2,
                    onNext: () => nextJugador(true),
                    onPrev: () => prevJugador(true),
                    onAddPlayer: () => abrirCrearJugador(true),
                    tema: tema,
                    posInferior: jugador1Index < 0,
                    posSuperior: jugador1Index >= jugadores.length
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      "VS",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(Utils.parseHex(tema.neonColor)),
                      ),
                    ),
                  ),
                  PlayerCard(
                    title: "Jugador 2",
                    jugador: jugador2,
                    rival: jugador1,
                    onNext: () => nextJugador(false),
                    onPrev: () => prevJugador(false),
                    onAddPlayer: () => abrirCrearJugador(false),
                    tema: tema,
                    posInferior: jugador2Index < 0,
                    posSuperior: jugador2Index >= jugadores.length
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => context.go('/menupartido'),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Color(Utils.parseHex(tema.buttonColor)),
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white,
                            width: 5
                          )
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(tema.borderRadius.toDouble()))
                      ),
                    child: Text(
                      'Volver',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color(Utils.parseHex(tema.neonColor))
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 40,),
                GestureDetector(
                  onTap: () => 
                  (jugador1Index > jugadores.length || jugador2Index > jugadores.length)
                  ? ()
                  : context.go('/splashCargaPartido', extra: {'jugador1Id': jugador1!.id , 'jugador2Id' : jugador2!.id}),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Color(Utils.parseHex(Provider.of<TemaProvider>(context).temaMarcador.buttonColor)),
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white,
                            width: 5
                          )
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(tema.borderRadius.toDouble()))
                      ),
                    child: Text(
                      'Empezar',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color(Utils.parseHex(tema.buttonColor))
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40,)
          ],
        ),
      ),
    );
  }

  void nextJugador(bool isJugador1) {
    // Guardamos el total de jugadores en la lista
    final provider = Provider.of<JugadorProvider>(context, listen: false);
    int currentTotal = provider.jugadores.length + 1;
    setState(() {
      if (isJugador1){
        // Actualizamos el index de la lista
        jugador1Index = ( jugador1Index +1 ) % currentTotal;
        // Si coinciden los index salta al siguiente
        if(jugador1Index == jugador2Index)  jugador1Index = ( jugador1Index +1 ) % currentTotal;

      }else{
        // Actualizamos el index de la lista
        jugador2Index = ( jugador2Index +1 ) % currentTotal;
        // Si coinciden los index salta al siguiente
        if(jugador1Index == jugador2Index)  jugador2Index = ( jugador2Index +1 ) % currentTotal;
      }
      // Comprobamos si tenemos que llamar a más jugadores de la api
      int currentIndex = isJugador1 ? jugador1Index : jugador2Index;
      if (currentTotal - 5 <= currentIndex) provider.getAllJugadores();
    });
  }

  void prevJugador(bool isJugador1) {
    final total = Provider.of<JugadorProvider>(context, listen: false).jugadores.length + 1;
    setState(() {
      if (isJugador1){
        jugador1Index = (jugador1Index - 1 + total) % total;
        if (jugador1Index == jugador2Index && jugador1Index < total - 1) jugador1Index = (jugador1Index - 1 + total) % total;
      }
      else{
        jugador2Index = (jugador2Index - 1 + total) % total;
        if (jugador2Index == jugador1Index && jugador1Index < total - 1) jugador2Index = (jugador2Index - 1 + total) % total;
      }
    });
  }

  void abrirCrearJugador(bool isJugador1) async {
    final nuevoJugador = await showModalBottomSheet<Jugador>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const CrearJugadorSheet(),
    );

    if (nuevoJugador != null) {
      setState(() {
        if (isJugador1) jugador1Index = Provider.of<JugadorProvider>(context, listen: false).jugadores.length - 1;
        else jugador2Index = Provider.of<JugadorProvider>(context, listen: false).jugadores.length - 1;
      });
    }
  }
}