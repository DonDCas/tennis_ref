import 'package:go_router/go_router.dart';
import 'package:tenis_pot3/models/partido_model.dart';
import 'package:tenis_pot3/presentations/screens/final_partido.dart';
import 'package:tenis_pot3/presentations/screens/historial_screen.dart';
import 'package:tenis_pot3/presentations/screens/home_screen.dart';
import 'package:tenis_pot3/presentations/screens/partido_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/partido',
      builder: (context, state) => PartidoScreen(),
    ),
    GoRoute(
      path: '/finPartido',
      builder: (context, state){
        final partidoFinalizado = state.extra as Partido;
        return FinalPartido(partido: partidoFinalizado,);
      } 
    ),
    GoRoute(
      path: '/historial',
      builder: (context, state) => HistorialScreen(),
    ),
  ]
);