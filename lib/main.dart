import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tenis_pot3/providers/jugador_provider.dart';
import 'package:tenis_pot3/providers/partido_provider.dart';
import 'package:tenis_pot3/providers/tema_provider.dart';
import 'package:tenis_pot3/routes/app_routes.dart';
import 'package:tenis_pot3/theme/app_theme.dart';

void main() {
  runApp(AppState());
}

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TemaProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => PartidoProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => JugadorProvider(),
          lazy: false,
        )
      ],
      child: MainApp(),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final temaProvider = Provider.of<TemaProvider>(context);
    final temaConfig = temaProvider.temaMenu;
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme.getTheme(
        fontFamily: temaConfig?.fontFamily,
        borderRadius: temaConfig?.borderRadius.toDouble(),
      )
    );
  }
}
