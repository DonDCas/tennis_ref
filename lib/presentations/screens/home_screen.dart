import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tenis_pot3/Utils/utils.dart';
import 'package:tenis_pot3/models/theme_config_model.dart';
import 'package:tenis_pot3/providers/tema_provider.dart';
import 'package:tenis_pot3/services/auth_service.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TemaConfig tema = Provider.of<TemaProvider>(context).temaMenu!;
    return Scaffold(
      backgroundColor: Color(Utils.parseHex(tema.primaryColor)),
      body:SafeArea(
        child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 400,
                  child: Image.asset('assets/images/logo-2.png'),
                ).fadeInLeft(),
                SizedBox(width: 30,),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 80,),
                    botonNavegacion('NUEVO PARTIDO', tema, ()=> context.go('/menupartido'), Duration(milliseconds: 800)),
                    SizedBox(height: 20,),
                    botonNavegacion('HISTORIAL', tema, ()=> context.go('/historialSplash'), Duration(milliseconds: 1000)),
                    SizedBox(height: 20,),
                    botonNavegacion('CERRAR SESIÓN', tema, (){
                          AuthService authService = AuthService();
                          authService.logout();
                          context.go("/");
                        }, Duration(milliseconds: 1200)),
                    SizedBox(height: 80,),
                  ],
                ),
              ],
            ),
          ),
      ),
    );
  }

  Widget botonNavegacion(String label, TemaConfig tema, Function goTo, Duration duracion){
    return Container(
      width: 260,
      height: 55,
      child: ElevatedButton(
        onPressed: () => goTo(), 
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(Utils.parseHex(tema.neonColor)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tema.borderRadius.toDouble()),
          ),
          textStyle: TextStyle(letterSpacing: 1.5),
        ),
        child: Text(
          '$label',
          style: TextStyle(
            color: Color(Utils.parseHex(tema.buttonColor)),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        )
      ),
    ).fadeInRight(duration: duracion);
  }
}
