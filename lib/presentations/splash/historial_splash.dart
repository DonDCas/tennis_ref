import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tennis_ref/Utils/utils.dart';
import 'package:tennis_ref/models/theme_config_model.dart';
import 'package:tennis_ref/providers/partido_provider.dart';
import 'package:tennis_ref/providers/tema_provider.dart';

class HistorialSplash extends StatefulWidget {
  const HistorialSplash({super.key});

  @override
  State<HistorialSplash> createState() => _HistorialSplashState();
}

class _HistorialSplashState extends State<HistorialSplash> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final partidoProvider = Provider.of<PartidoProvider>(context, listen: false);
    await partidoProvider.getAllPatidos();
    if (mounted) {
      context.pushReplacement('/historial');
    }
  }

  @override
  Widget build(BuildContext context) {
    TemaConfig tema = Provider.of<TemaProvider>(context).temaMarcador;
    return Scaffold(
      backgroundColor: Color(Utils.parseHex(tema.primaryColor)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/gif/Tennis_Ball.gif', width: 120),
            const SizedBox(height: 20),
            const Text("Recuperando historial de partidos...", 
              style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}