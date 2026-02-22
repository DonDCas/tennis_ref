import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tennis_ref/Utils/utils.dart';
import 'package:tennis_ref/models/jugador_model.dart';
import 'package:tennis_ref/models/partido_model.dart';
import 'package:tennis_ref/models/theme_config_model.dart';
import 'package:tennis_ref/providers/jugador_provider.dart';
import 'package:tennis_ref/providers/partido_provider.dart';
import 'package:tennis_ref/providers/tema_provider.dart';

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
            Image.asset('assets/gif/Tennis_Ball.gif'),
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
    final partidoProvider = Provider.of<PartidoProvider>(context);
    final jugadorProvider = Provider.of<JugadorProvider>(context);
    final tema = Provider.of<TemaProvider>(context).temaMarcador;
    final partidos = partidoProvider.partidosHistorial;

    return Scaffold(
      backgroundColor: Color(Utils.parseHex(tema.primaryColor)),
      appBar: AppBar(
        backgroundColor: Color(Utils.parseHex(tema.primaryColor)),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: partidoProvider.isSearching
            ? TextField(
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Buscar competición...",
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
                onChanged: (value) => partidoProvider.getAllPatidos(query: value),
              )
            : Text("Historial", style: TextStyle(color: Color(Utils.parseHex(tema.textColor)))),
        actions: [
          IconButton(
            icon: Icon(
                  partidoProvider.isSearching ? Icons.close : Icons.search,
                  color: Color(Utils.parseHex(tema.neonColor))
                ),
            onPressed: () => partidoProvider.setSearching(!partidoProvider.isSearching),
          ),
          IconButton(
            onPressed: () => context.go('/'),
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Color(Utils.parseHex(tema.neonColor))
            )
          ),
          SizedBox(width: 20)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildHeaderTable(tema),
            Expanded(
              child: partidoProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: partidos.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) => _buildRow(partidos[index], jugadorProvider, tema),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(Partido partido, JugadorProvider jugadorProvider, TemaConfig tema) {
    // Buscamos el nombre del ganador por ID
    final ganador = jugadorProvider.jugadores.firstWhere(
      (j) => j.id == partido.ganador,
      orElse: () => Jugador(nombreCompleto: "---", pais: "", bandera: "", fechaNacimiento: DateTime.now(), rankingAtp: 0, mejorRanking: 0, manoDominante: "D", foto: "", creacion: DateTime.now(), actualizacion: DateTime.now()),
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          headerCell(Utils.formatFechaString(partido.fechaIniciado ?? ""), Colors.white70),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(partido.competicion, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                Text(Utils.conversorFase(partido.fase), style: TextStyle(color: Color(Utils.parseHex(tema.neonColor)), fontSize: 10)),
              ],
            ),
          ),
          headerCell(ganador.nombreCompleto, Color(Utils.parseHex(tema.neonColor))),
          Expanded(flex: 2, child: _buildPuntosSets(partido, tema)),
        ],
      ),
    );
  }

  Widget _buildPuntosSets(Partido partido, TemaConfig tema) {
    if (partido.participantes.length < 2) return const Text("-");
    final p1 = partido.participantes[0];
    final p2 = partido.participantes[1];

    String setStr(int s1, int s2) => s1 == 0 && s2 == 0 ? "" : "$s1-$s2";
    List<String> scores = [];
    if (setStr(p1.sets1, p2.sets1).isNotEmpty) scores.add(setStr(p1.sets1, p2.sets1));
    if (setStr(p1.sets2, p2.sets2).isNotEmpty) scores.add(setStr(p1.sets2, p2.sets2));
    if (setStr(p1.sets3, p2.sets3).isNotEmpty) scores.add(setStr(p1.sets3, p2.sets3));

    return Text(
      scores.join(" / "),
      textAlign: TextAlign.center,
      style: GoogleFonts.getFont(tema.fontFamily, color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
    );
  }

  Widget _buildHeaderTable(TemaConfig tema) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(Utils.parseHex(tema.buttonColor)),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: Row(
        children: [
          headerCell('Fecha', Color(Utils.parseHex(tema.textColor))),
          headerCell('Torneo', Color(Utils.parseHex(tema.textColor))),
          headerCell('Ganador', Color(Utils.parseHex(tema.textColor))),
          headerCell('Resultado', Color(Utils.parseHex(tema.textColor))),
        ],
      ),
    );
  }
}

Widget headerCell(String texto, Color color){
  return Expanded(
    flex: 2,
    child: Text(
      texto,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: color,
        fontSize: 14,
        fontWeight: FontWeight.bold
      ),
    )
  );
}