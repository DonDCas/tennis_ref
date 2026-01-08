import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tenis_pot3/models/theme_config_model.dart';
import 'package:tenis_pot3/services/theme_config_service.dart';

class SplashInicio extends StatefulWidget {
  const SplashInicio({super.key});

  @override
  State<SplashInicio> createState() => _SplashInicioState();
}

class _SplashInicioState extends State<SplashInicio> {
  TemaConfig? tema = null;
  ThemeConfigService temaService = ThemeConfigService();
  @override
  void initState() {
    cargarTema();
  }
  @override
  Widget build(BuildContext context) {
    if (tema == null) return Scaffold(body:Center(child: Image.asset("assets/gif/Tennis_Ball.gif"),));
    return Scaffold(body: Center(child: Image.asset("assets/gif/Tennis_Ball.gif"),));
  }

  void cargarTema() async{
    final data = await temaService.getTema("menu");
    setState(() {
      if (data != null){
        setState(() async{
          tema = data;
          await Future.delayed(Duration(seconds: 10));
          context.go("/login", extra: tema);
        });
      }
    });
  }
}