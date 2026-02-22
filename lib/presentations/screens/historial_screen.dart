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

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final partidoProvider = Provider.of<PartidoProvider>(context);
    final jugadorProvider = Provider.of<JugadorProvider>(context);
    final tema = Provider.of<TemaProvider>(context).temaMarcador;
    final partidos = partidoProvider.partidosHistorial;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(Utils.parseHex(tema.primaryColor)),
      appBar: AppBar(
        backgroundColor: Color(Utils.parseHex(tema.primaryColor)),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: partidoProvider.isSearching
            ? _buildSearchField(partidoProvider)
            : Text("Historial de Partidos", 
                style: TextStyle(color: Color(Utils.parseHex(tema.textColor)))),
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
            icon: Icon(Icons.home_filled, color: Color(Utils.parseHex(tema.neonColor)))
          ),
          const SizedBox(width: 10)
        ],
      ),
      body: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width > 1000 ? size.width * 0.15 : 20, 
            vertical: 10
          ),
          child: Column(
            children: [
              _buildHeaderTable(tema),
              Expanded(
                child: partidoProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : partidos.isEmpty 
                      ? const Center(child: Text("No se encontraron partidos", style: TextStyle(color: Colors.white54)))
                      : ListView.separated(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(top: 10, bottom: 20),
                          itemCount: partidos.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (context, index) => _buildRow(partidos[index], jugadorProvider, tema),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(PartidoProvider provider) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        autofocus: true,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: "Buscar por torneo...",
          hintStyle: TextStyle(color: Colors.white54),
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Colors.white54),
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
        onChanged: (value) => provider.getAllPatidos(query: value),
      ),
    );
  }

  Widget _buildRow(Partido partido, JugadorProvider jugadorProvider, TemaConfig tema) {
    final ganador = jugadorProvider.jugadores.firstWhere(
      (j) => j.id == partido.ganador,
      orElse: () => Jugador(nombreCompleto: "Desconocido", pais: "", bandera: "", fechaNacimiento: DateTime.now(), rankingAtp: 0, mejorRanking: 0, manoDominante: "D", foto: "", creacion: DateTime.now(), actualizacion: DateTime.now()),
    );

    return InkWell( // InkWell para efecto hover en Web
      onTap: () {
        // Podrías navegar a un detalle del partido aquí
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            headerCell(Utils.formatFechaString(partido.fechaIniciado ?? ""), Colors.white70),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text(partido.competicion, 
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(Utils.conversorFase(partido.fase), 
                    style: TextStyle(color: Color(Utils.parseHex(tema.neonColor)), fontSize: 11)),
                ],
              ),
            ),
            headerCell(ganador.nombreCompleto, Color(Utils.parseHex(tema.neonColor))),
            Expanded(flex: 2, child: _buildPuntosSets(partido, tema)),
          ],
        ),
      ),
    );
  }

  Widget _buildPuntosSets(Partido partido, TemaConfig tema) {
    if (partido.participantes.length < 2) return const Text("-", style: TextStyle(color: Colors.white));
    final p1 = partido.participantes[0];
    final p2 = partido.participantes[1];

    String setStr(int s1, int s2) => (s1 == 0 && s2 == 0) ? "" : "$s1-$s2";
    
    List<String> scores = [];
    if (setStr(p1.sets1, p2.sets1).isNotEmpty) scores.add(setStr(p1.sets1, p2.sets1));
    if (setStr(p1.sets2, p2.sets2).isNotEmpty) scores.add(setStr(p1.sets2, p2.sets2));
    if (setStr(p1.sets3, p2.sets3).isNotEmpty) scores.add(setStr(p1.sets3, p2.sets3));

    return Text(
      scores.isEmpty ? "No score" : scores.join(" / "),
      textAlign: TextAlign.center,
      style: GoogleFonts.getFont(tema.fontFamily, 
        color: Colors.white, 
        fontWeight: FontWeight.bold, 
        fontSize: 15
      ),
    );
  }

  Widget _buildHeaderTable(TemaConfig tema) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      decoration: BoxDecoration(
        color: Color(Utils.parseHex(tema.buttonColor)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          headerCell('FECHA', Color(Utils.parseHex(tema.textColor))),
          headerCell('TORNEO / FASE', Color(Utils.parseHex(tema.textColor))),
          headerCell('GANADOR', Color(Utils.parseHex(tema.textColor))),
          headerCell('RESULTADO FINAL', Color(Utils.parseHex(tema.textColor))),
        ],
      ),
    );
  }
}

Widget headerCell(String texto, Color color) {
  return Expanded(
    flex: 2,
    child: Text(
      texto.toUpperCase(),
      textAlign: TextAlign.center,
      style: TextStyle(
        color: color,
        fontSize: 12,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.1
      ),
    )
  );
}