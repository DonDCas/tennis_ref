import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tenis_pot3/Utils/utils.dart';
import 'package:tenis_pot3/models/theme_config_model.dart';
import 'package:tenis_pot3/providers/tema_provider.dart';
import 'package:tenis_pot3/services/auth_service.dart';
import 'package:tenis_pot3/services/theme_config_service.dart';


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
                    Container(
                      width: 260,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: (){
                          context.go("/menupartido", extra: tema);
                        }, 
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(Utils.parseHex(tema.neonColor)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(tema.borderRadius.toDouble()),
                          ),
                          textStyle: TextStyle(letterSpacing: 1.5),
                        ),
                        child: Text(
                          "NUEVO PARTIDO",
                          style: GoogleFonts.getFont(
                            tema.fontFamily,
                            color: Color(Utils.parseHex(tema.buttonColor)),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ),
                    ).fadeInRight(),
                    SizedBox(height: 20,),
                    Container(
                      width: 260,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: (){
                          context.go("/historialSplash");
                        }, 
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(Utils.parseHex(tema.neonColor)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(tema.borderRadius.toDouble()),
                          ),
                          textStyle: TextStyle(letterSpacing: 1.5)
                        ),
                        child: Text(
                          "HISTORIAL",
                          style: GoogleFonts.getFont(
                            tema.fontFamily,
                            color: Color(Utils.parseHex(tema.buttonColor)),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ),
                    ).fadeInRight(duration: Duration(milliseconds: 1000)),
                    SizedBox(height: 20,),
                    Container(
                      width: 260,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: (){
                          AuthService authService = AuthService();
                          authService.logout();
                          context.go("/");
                        }, 
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(Utils.parseHex(tema.neonColor)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(tema.borderRadius.toDouble()),
                          ),
                          textStyle: TextStyle(letterSpacing: 1.5)
                        ),
                        child: Text(
                          "CERRAR SESIÓN",
                          style: TextStyle(
                            color: Color(Utils.parseHex(tema.buttonColor)),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ),
                    ).fadeInRight(duration: Duration(milliseconds: 1200)),
                    SizedBox(height: 80,),
                  ],
                ),
              ],
            ),
          ),
      ),
    );
  }
}
