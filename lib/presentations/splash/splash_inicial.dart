import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tennis_ref/providers/tema_provider.dart';
import 'package:tennis_ref/services/auth_service.dart';

class SplashInicial extends StatefulWidget {

  const SplashInicial({super.key});

  @override
  State<SplashInicial> createState() => _SplashInicialState();
}

class _SplashInicialState extends State<SplashInicial> {

  @override
  void initState() {
    super.initState();
    _iniciarCarga();
  }

  Future<void> _iniciarCarga() async {
    final temaProvider = Provider.of<TemaProvider>(context, listen: false);
    
    // Esperamos a que la lógica del provider (con sus delays) termine
    await temaProvider.getTemaMenu();
    await temaProvider.getTemaMarcador();

    if (mounted) {
      
      print('Tema cargado');
      chequeoAuth(context);
    }
  }

  @override
  void dispose() {
    // Al navegar con .go, este método se dispara garantizando que el GIF muere
    print("Recursos del Splash liberados");
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    print('Splash inicial');
    final temaProvider = Provider.of<TemaProvider>(context, listen: false);
    print('Cargamos tema');
    if (!temaProvider.isLoading){
    
    } 
    print('Estamos cargando tema');
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/gif/Tennis_Ball.gif'),
            Text(
              'Cargando Datos',
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 20
              )              
            ),
          ],
        ),
      )
    );
  }
  
  void chequeoAuth(BuildContext context) async{
    print('chequeando ...');
    AuthService auth = AuthService();
    bool logueado = await auth.estaLogueado();
    if (logueado){
      context.go('/home');
    }else{
      context.go('/login');
    }
  }
}
