import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:tenis_pot3/Utils/utils.dart';
import 'package:tenis_pot3/models/theme_config_model.dart';
import 'package:tenis_pot3/services/theme_config_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ThemeConfigService themeConfigService = ThemeConfigService();
  TemaConfig? tema;

  @override
  void initState() {
    super.initState();
    cargarTema();
  }
  void cargarTema() async {
    final data = await themeConfigService.getTema("menu");
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      tema = data;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (tema == null ) ? Colors.white : Color(Utils.parseHex(tema!.primaryColor)),
      body: (tema == null) ? Center(child: Image.asset("assets/gif/Tennis_Ball.gif"),) : Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("APP TENNIS SCORE V1.0",
                style: GoogleFonts.getFont(
                  tema!.fontFamily,
                  color: Color(Utils.parseHex(tema!.textColor)),
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),),
                const SizedBox(height: 40,),
                Container(
                  width: 260,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: (){
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(Utils.parseHex(tema!.neonColor)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: TextStyle(letterSpacing: 1.5),
                      );
                      context.go("/partido");
                    }, 
                    child: Text(
                      "NUEVO PARTIDO",
                      style: GoogleFonts.getFont(
                        tema!.fontFamily,
                        color: Color(Utils.parseHex(tema!.neonColor)),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  width: 260,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: (){
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(Utils.parseHex(tema!.neonColor)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: TextStyle(letterSpacing: 1.5)
                      );
                      context.go("/historial");
                    }, 
                    child: Text(
                      "HISTORIAL",
                      style: GoogleFonts.getFont(
                        tema!.fontFamily,
                        color: Color(Utils.parseHex(tema!.neonColor)),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ),
                ),
                SizedBox(height: 80,),
              ],
            ),
          )
        ],
      ),
    );
  }
}
