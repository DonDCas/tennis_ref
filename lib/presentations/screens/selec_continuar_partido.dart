import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tennis_ref/Utils/utils.dart';
import 'package:tennis_ref/models/partido_model.dart';
import 'package:tennis_ref/models/theme_config_model.dart';
import 'package:tennis_ref/providers/partido_provider.dart';
import 'package:tennis_ref/providers/tema_provider.dart';

class SeleccionContinuarPartidoScreen extends StatefulWidget {
  const SeleccionContinuarPartidoScreen({super.key});

  @override
  State<SeleccionContinuarPartidoScreen> createState() => _SeleccionContinuarPartidoScreenState();
}

class _SeleccionContinuarPartidoScreenState extends State<SeleccionContinuarPartidoScreen> {
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final partidoProvider = Provider.of<PartidoProvider>(context, listen: false);
      
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        if (!partidoProvider.isLoading) {
          partidoProvider.getPartidosEmpezados();
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PartidoProvider>(context, listen: false).getPartidosEmpezados(resetPage: true);
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
                onChanged: (value) {
                  if (_debounce?.isActive ?? false) _debounce!.cancel();
                  _debounce = Timer(const Duration(milliseconds: 500), () {
                    partidoProvider.getPartidosEmpezados(query: value, resetPage: true);
                  });
                },
              )
            : Text("Partidos Empezados", 
                style: TextStyle(color: Color(Utils.parseHex(tema.textColor)))),
        actions: [
          IconButton(
            icon: Icon(
              partidoProvider.isSearching ? Icons.close : Icons.search,
              color: Color(Utils.parseHex(tema.neonColor))
            ),
            onPressed: () {
              if (partidoProvider.isSearching) {
                partidoProvider.getPartidosEmpezados(resetPage: true);
              }
              partidoProvider.setSearching(!partidoProvider.isSearching);
            },
          ),
          IconButton(
            onPressed: () => context.go('/menupartido'),
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Color(Utils.parseHex(tema.neonColor))
            )
          ),
          const SizedBox(width: 20)
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => partidoProvider.getPartidosEmpezados(resetPage: false),
        child: Column(
          children: [
            _buildHeaderTable(tema),
            Expanded(
              child: partidos.isEmpty && partidoProvider.isLoading
                ? _buildLoadingGif()
                : ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  itemCount: partidos.length + (partidoProvider.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == partidos.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: CircularProgressIndicator(color: Colors.white),
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
    );
  }

  Widget _buildLoadingGif() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/gif/Tennis_Ball.gif', width: 100),
          const SizedBox(height: 20),
          const Text('Buscando partidos disponibles...', 
            style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildPartidoCard(Partido partido, TemaConfig tema, PartidoProvider partidoProvider) {
    return Card(
      color: Color(Utils.parseHex(tema.tableRowColor ?? '#2c2c2c', transparencia: 'AA')),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Row(
          children: [
            headerCell(partido.fechaIniciado ?? 'N/A', Colors.white70),
            headerCell(partido.competicion, Colors.white70),
            headerCell(Utils.conversorFase(partido.fase), Colors.white70),
            headerCell( 
              partido.participantes.isNotEmpty 
                ? '${partido.participantes[0].jugadorNombre}\nVS\n${partido.participantes[1].jugadorNombre}' 
                : 'TBD', 
              Color(Utils.parseHex(tema.neonColor))
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.white54),
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
          headerCell('Fase', Color(Utils.parseHex(tema.textColor))),
          headerCell('Jugadores', Color(Utils.parseHex(tema.textColor))),
          const SizedBox(width: 40) // Espacio para el chevron del trailing
        ],
      ),
    );
  }

  Widget headerCell(String texto, Color color) {
    return Expanded(
      child: Text(
        texto,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold
        ),
      )
    );
  }
}