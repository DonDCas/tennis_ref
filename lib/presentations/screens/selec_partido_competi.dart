import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tennis_ref/Utils/utils.dart';
import 'package:tennis_ref/models/partido_model.dart';
import 'package:tennis_ref/models/theme_config_model.dart';
import 'package:tennis_ref/providers/partido_provider.dart';
import 'package:tennis_ref/providers/tema_provider.dart';

class SeleccionCompeticionScreen extends StatefulWidget {
  const SeleccionCompeticionScreen({super.key});

  @override
  State<SeleccionCompeticionScreen> createState() => _SeleccionCompeticionScreenState();
}

class _SeleccionCompeticionScreenState extends State<SeleccionCompeticionScreen> {
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final partidoProvider = Provider.of<PartidoProvider>(context, listen: false);
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        if (!partidoProvider.isLoading) {
          partidoProvider.getPartidosOficiales();
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PartidoProvider>(context, listen: false).getPartidosOficiales(resetPage: true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final partidoProvider = Provider.of<PartidoProvider>(context);
    final tema = Provider.of<TemaProvider>(context).temaMarcador;
    final partidos = partidoProvider.partidosSinEmpezar;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(Utils.parseHex(tema.primaryColor)),
      appBar: AppBar(
        backgroundColor: Color(Utils.parseHex(tema.primaryColor)),
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: partidoProvider.isSearching
            ? Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  autofocus: true,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: "Buscar torneo o jugador...",
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.white54),
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  onChanged: (value) {
                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                    _debounce = Timer(const Duration(milliseconds: 500), () {
                      partidoProvider.getPartidosOficiales(query: value, resetPage: true);
                    });
                  },
                ),
              )
            : Text("Partidos Oficiales", 
                style: TextStyle(color: Color(Utils.parseHex(tema.textColor)))),
        actions: [
          IconButton(
            icon: Icon(
              partidoProvider.isSearching ? Icons.close : Icons.search,
              color: Color(Utils.parseHex(tema.neonColor))
            ),
            onPressed: () {
              if (partidoProvider.isSearching) {
                partidoProvider.getPartidosOficiales(resetPage: true);
              }
              partidoProvider.setSearching(!partidoProvider.isSearching);
            },
          ),
          IconButton(
            onPressed: () => context.go('/menupartido'),
            icon: Icon(Icons.arrow_back_ios_new, color: Color(Utils.parseHex(tema.neonColor)))
          ),
          const SizedBox(width: 10)
        ],
      ),
      // Scrollbar es vital para Web
      body: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true, 
        child: RefreshIndicator(
          onRefresh: () => partidoProvider.getPartidosOficiales(resetPage: true),
          child: Column(
            children: [
              _buildHeaderTable(tema, size),
              Expanded(
                child: partidos.isEmpty && partidoProvider.isLoading
                    ? _buildLoadingGif()
                    : ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        // Limitar el ancho en pantallas grandes (Web)
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width > 900 ? size.width * 0.1 : 10, 
                          vertical: 10
                        ),
                        itemCount: partidos.length + (partidoProvider.isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == partidos.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          return _buildPartidoCard(partidos[index], tema, partidoProvider);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingGif() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/gif/Tennis_Ball.gif', width: 80),
          const SizedBox(height: 20),
          const Text('Cargando partidos...', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildPartidoCard(Partido partido, TemaConfig tema, PartidoProvider partidoProvider) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Color(Utils.parseHex(tema.tableRowColor ?? '#2c2c2c')).withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        hoverColor: Colors.white10, // Feedback visual para mouse en Web
        title: Row(
          children: [
            headerCell(partido.fechaIniciado ?? 'TBD', Colors.white70),
            headerCell(partido.competicion, Colors.white, isBold: true),
            headerCell(Utils.conversorFase(partido.fase), Colors.white70),
            headerCell( 
              partido.participantes.length >= 2
                ? '${partido.participantes[0].jugadorNombre} vs ${partido.participantes[1].jugadorNombre}' 
                : 'Por definir', 
              Color(Utils.parseHex(tema.neonColor))
            ),
          ],
        ),
        trailing: const Icon(Icons.play_circle_outline, color: Colors.white38),
        onTap: () {
          partidoProvider.eligePartido(partido);
          context.go(
            '/splashCargaPartido',
            extra: {
              'jugador1Id': partido.participantes[0].jugador , 
              'jugador2Id': partido.participantes[1].jugador
            }
          );
        },
      ),
    );
  }

  Widget _buildHeaderTable(TemaConfig tema, Size size) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: size.width > 900 ? size.width * 0.1 : 10,
        vertical: 10
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Color(Utils.parseHex(tema.buttonColor)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          headerCell('FECHA', Color(Utils.parseHex(tema.textColor))),
          headerCell('TORNEO', Color(Utils.parseHex(tema.textColor))),
          headerCell('FASE', Color(Utils.parseHex(tema.textColor))),
          headerCell('ENFRENTAMIENTO', Color(Utils.parseHex(tema.textColor))),
          const SizedBox(width: 30) 
        ],
      ),
    );
  }

  Widget headerCell(String texto, Color color, {bool isBold = false}) {
    return Expanded(
      child: Text(
        texto,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal
        ),
      )
    );
  }
}