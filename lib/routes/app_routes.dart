
import 'package:go_router/go_router.dart';
import 'package:tenis_pot3/presentations/screens/home_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/partido',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/finPartido',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/historial',
      builder: (context, state) => const HomeScreen(),
    ),
  ]
);