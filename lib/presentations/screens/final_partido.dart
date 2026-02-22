import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tennis_ref/Utils/utils.dart';
import 'package:tennis_ref/models/jugador_model.dart';
import 'package:tennis_ref/models/partido_model.dart';
import 'package:tennis_ref/models/theme_config_model.dart';
import 'package:tennis_ref/providers/jugador_provider.dart';
import 'package:tennis_ref/providers/partido_provider.dart';
import 'package:tennis_ref/providers/tema_provider.dart';

class FinalPartido extends StatelessWidget {
  const FinalPartido({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Provider.of<TemaProvider>(context).temaMarcador;
    final partido = Provider.of<PartidoProvider>(context).partidoEnJuego!;
    final jProvider = Provider.of<JugadorProvider>(context);

    final bool ganoPrimero =
        partido.participantes[0].jugador == partido.ganador;

    final pGanador = ganoPrimero
        ? partido.participantes[0]
        : partido.participantes[1];
    final pPerdedor = ganoPrimero
        ? partido.participantes[1]
        : partido.participantes[0];
    final jganador = ganoPrimero
        ? jProvider.jugadorEnJuego1
        : jProvider.jugadorEnJuego2;
    final jperdedor = ganoPrimero
        ? jProvider.jugadorEnJuego2
        : jProvider.jugadorEnJuego1;

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(Utils.parseHex(tema.primaryColor)),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 40.0,
              horizontal: 20.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'PARTIDO FINALIZADO',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Color(Utils.parseHex(tema.textColor)),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  width: size.width > 800 ? 600 : size.width * 0.9,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(
                      Utils.parseHex(tema.tableRowColor ?? "#222222"),
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 20,
                        color: Color(
                          Utils.parseHex(tema.neonColor),
                        ).withOpacity(0.5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      AvatarJugador(jugador: jganador, tema: tema),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              jganador.nombreCompleto,
                              style: TextStyle(
                                color: Color(Utils.parseHex(tema.textColor)),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              jganador.pais,
                              style: TextStyle(
                                color: Color(Utils.parseHex(tema.neonColor)),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Resultado",
                            style: TextStyle(
                              color: Color(Utils.parseHex(tema.neonColor)),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              _Resultado(
                                tema: tema,
                                ganador: pGanador,
                                perdedor: pPerdedor,
                                numSet: 0,
                              ),
                              _divisor(tema),
                              _Resultado(
                                tema: tema,
                                ganador: pGanador,
                                perdedor: pPerdedor,
                                numSet: 1,
                              ),
                              _divisor(tema),
                              _Resultado(
                                tema: tema,
                                ganador: pGanador,
                                perdedor: pPerdedor,
                                numSet: 2,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  jperdedor.nombreCompleto,
                  style: const TextStyle(color: Colors.white70, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ResultadoPerdedor(
                      tema: tema,
                      ganador: pGanador,
                      perdedor: pPerdedor,
                      numSet: 0,
                    ),
                    _divisorPerdedor(tema),
                    _ResultadoPerdedor(
                      tema: tema,
                      ganador: pGanador,
                      perdedor: pPerdedor,
                      numSet: 1,
                    ),
                    _divisorPerdedor(tema),
                    _ResultadoPerdedor(
                      tema: tema,
                      ganador: pGanador,
                      perdedor: pPerdedor,
                      numSet: 2,
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<PartidoProvider>(
                      context,
                      listen: false,
                    ).deselecPartido(partido);
                    context.go("/");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(Utils.parseHex(tema.neonColor)),
                    minimumSize: const Size(300, 65),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        tema.borderRadius.toDouble(),
                      ),
                    ),
                  ),
                  child: Text(
                    'VOLVER AL MENÚ',
                    style: TextStyle(
                      color: Color(Utils.parseHex(tema.primaryColor)),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _divisor(TemaConfig tema) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Text(
      '|',
      style: TextStyle(
        color: Color(Utils.parseHex(tema.neonColor)),
        fontSize: 24,
      ),
    ),
  );

  Widget _divisorPerdedor(TemaConfig tema) => const Padding(
    padding: EdgeInsets.symmetric(horizontal: 8),
    child: Text('|', style: TextStyle(color: Colors.white24, fontSize: 14)),
  );
}

class AvatarJugador extends StatelessWidget {
  final TemaConfig tema;
  final Jugador jugador;

  const AvatarJugador({super.key, required this.jugador, required this.tema});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Color(Utils.parseHex(tema.neonColor)),
          width: 3,
        ),
      ),
      child: ClipOval(
        child: Image.network(
          jugador.foto,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.person, size: 40, color: Colors.white),
        ),
      ),
    );
  }
}

class _Resultado extends StatelessWidget {
  final TemaConfig tema;
  final Participante ganador;
  final Participante perdedor;
  final int numSet;

  const _Resultado({
    super.key,
    required this.tema,
    required this.ganador,
    required this.perdedor,
    required this.numSet,
  });

  @override
  Widget build(BuildContext context) {
    String res = "";
    if (numSet == 0) res = '${ganador.sets1} - ${perdedor.sets1}';
    if (numSet == 1) res = '${ganador.sets2} - ${perdedor.sets2}';
    if (numSet == 2) res = '${ganador.sets3} - ${perdedor.sets3}';

    return Text(
      res,
      style: TextStyle(
        color: Color(Utils.parseHex(tema.neonColor)),
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _ResultadoPerdedor extends StatelessWidget {
  final TemaConfig tema;
  final Participante ganador;
  final Participante perdedor;
  final int numSet;

  const _ResultadoPerdedor({
    super.key,
    required this.tema,
    required this.ganador,
    required this.perdedor,
    required this.numSet,
  });

  @override
  Widget build(BuildContext context) {
    String res = "";
    if (numSet == 0) res = '${ganador.sets1} - ${perdedor.sets1}';
    if (numSet == 1) res = '${ganador.sets2} - ${perdedor.sets2}';
    if (numSet == 2) res = '${ganador.sets3} - ${perdedor.sets3}';

    return Text(
      res,
      style: const TextStyle(color: Colors.white38, fontSize: 16),
    );
  }
}
