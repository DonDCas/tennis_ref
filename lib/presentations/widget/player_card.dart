
import 'package:flutter/material.dart';
import 'package:tennis_ref/Utils/utils.dart';
import 'package:tennis_ref/models/jugador_model.dart';
import 'package:tennis_ref/models/theme_config_model.dart';

class PlayerCard extends StatelessWidget {
  final String title;
  final Jugador? jugador;
  final Jugador? rival;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final VoidCallback onAddPlayer;
  final TemaConfig tema;
  final bool posInferior;
  final bool posSuperior;

  const PlayerCard({
    super.key,
    required this.title,
    required this.jugador,
    required this.rival,
    required this.onNext,
    required this.onPrev,
    required this.onAddPlayer,
    required this.tema, 
    required this.posInferior,
    required this.posSuperior,
  });

  @override
  Widget build(BuildContext context) {
    // Si no hay jugador en ese índice, mostramos la tarjeta de añadir
    if (jugador == null) {
      return _addPlayerCard(posInferior,posSuperior);
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
            style: TextStyle(color: Color(Utils.parseHex(tema.neonColor))),
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
            style: TextStyle(fontSize: 20, color: Color(Utils.parseHex(tema.neonColor))),
          ),
          const SizedBox(height: 8),
          Text(
            'RANKING ${jugador!.rankingAtp}',
            style: TextStyle(color: Color(Utils.parseHex(tema.neonColor))),
          ),
        ],
      ),
    );
  }

  Widget _addPlayerCard(bool posInferior, bool posSuperior) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Positioned(
                  left: 0,
                  child: IconButton(
                    iconSize: 50,
                    onPressed: onPrev,
                    icon: Icon(Icons.chevron_left, color: Color(Utils.parseHex(tema.neonColor))),
                  ),
                ),
                Icon(Icons.add_circle_outline, size: 80, color: Color(Utils.parseHex(tema.neonColor))),
                Positioned(
                  left: 0,
                  child: IconButton(
                    iconSize: 50,
                    onPressed: onNext,
                    icon: Icon(Icons.chevron_right, color: Color(Utils.parseHex(tema.neonColor))),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "ADD PLAYER",
              style: TextStyle(color: Color(Utils.parseHex(tema.neonColor))),
            ),
          ],
        ),
      ),
    );
  }
}