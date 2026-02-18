import 'package:go_router/go_router.dart';
import 'package:tennis_ref/models/partido_model.dart';
import 'package:tennis_ref/models/theme_config_model.dart';
import 'package:tennis_ref/presentations/screens/select_jugadores_screen.dart';
import 'package:tennis_ref/presentations/screens/final_partido.dart';
import 'package:tennis_ref/presentations/screens/historial_screen.dart';
import 'package:tennis_ref/presentations/screens/home_screen.dart';
import 'package:tennis_ref/presentations/screens/login_screen.dart';
import 'package:tennis_ref/presentations/screens/menu_partido_screen.dart';
import 'package:tennis_ref/presentations/screens/partido_screen.dart';
import 'package:tennis_ref/presentations/splash/splash_CargaPartido.dart';
import 'package:tennis_ref/presentations/splash/splash_inicial.dart';
import 'package:tennis_ref/presentations/splash/splash_jugadores_amistoso.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => SplashInicial() 
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen()
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen()
    ),
    GoRoute(
      path: '/menupartido',
      builder: (context, state) => MenuPartidoScreen(),
    ),
    GoRoute(
      path: '/selectjugadores',
      builder: (context, state) => SelectJugadoresScreen()
    ),GoRoute(
    path: '/splashCargaPartido',
    builder: (context, state) {
      // Extraemos el Map
      final extras = state.extra as Map<String, dynamic>;
      
      return SplashCargaPartido(
          jugador1Id: extras['jugador1Id'] as String,
          jugador2Id: extras['jugador2Id'] as String,
        );
      }
    ),
    /* GoRoute(
      path: '/partido',
      builder: (context, state) => PartidoScreen(),
    ), */
    GoRoute(
      path: '/finPartido',
      builder: (context, state){
        final partidoFinalizado = state.extra as Partido;
        return FinalPartido(partido: partidoFinalizado,);
      } 
    ),
    GoRoute(
      path: '/historialSplash',
      builder: (context, state) => HistorialSplash(),
    ),
    GoRoute(
      path: '/historial',
      builder: (context, state) => HistorialScreen(),
    ),
  ]
);