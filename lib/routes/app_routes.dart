import 'package:go_router/go_router.dart';
import 'package:tenis_pot3/models/partido_model.dart';
import 'package:tenis_pot3/models/theme_config_model.dart';
import 'package:tenis_pot3/presentations/screens/Select_Jugadores_Screen.dart';
import 'package:tenis_pot3/presentations/screens/final_partido.dart';
import 'package:tenis_pot3/presentations/screens/historial_screen.dart';
import 'package:tenis_pot3/presentations/screens/home_screen.dart';
import 'package:tenis_pot3/presentations/screens/login_screen.dart';
import 'package:tenis_pot3/presentations/screens/menu_partido_screen.dart';
import 'package:tenis_pot3/presentations/screens/partido_screen.dart';
import 'package:tenis_pot3/presentations/splash/splash_inicial.dart';
import 'package:tenis_pot3/presentations/splash/splash_jugadores_amistoso.dart';

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
      builder: (context, state){
        final temaMenu = state.extra as TemaConfig;
        return MenuPartidoScreen(temaConfig: temaMenu);
        },
    ),
    GoRoute(
      path: '/splashamistoso',
      builder: (context, state){
        final temaMenu = state.extra as TemaConfig;
        return SplashJugadoresAmistosos(temaConfig: temaMenu);
        },
    ),
    GoRoute(
      path: '/selectjugadores',
      builder: (context, state) => SelectJugadoresScreen()
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