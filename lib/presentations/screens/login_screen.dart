import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tennis_ref/Utils/utils.dart';
import 'package:tennis_ref/models/theme_config_model.dart';
import 'package:tennis_ref/providers/tema_provider.dart';
import 'package:tennis_ref/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
    
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  void dispose(){
    userController.dispose();
    passController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final temaProvider = Provider.of<TemaProvider>(context);
    TemaConfig tema = temaProvider.temaMenu!;
    return Scaffold(
      backgroundColor: Color(Utils.parseHex(tema.primaryColor)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Image.asset(
                "assets/images/logo-2.png",
                width: 200,
              ),
              SizedBox(height: 10,),
              InsertText(
                tema, 'FF', 
                Icon(Icons.person_2, size: 18),
                'Usuario o email',
                false,
                controller: userController
              ),
              SizedBox(height: 10,),
              InsertText(
                tema, 'FF', 
                Icon(Icons.lock, size: 18),
                'Contraseña',
                true,
                controller: passController
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async{
                      final user = userController.text.trim().toLowerCase();
                      final pass = passController.text.trim();
                      if (user.isEmpty || pass.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Completa el inicio de sesión'))
                        );
                        return;
                      }
                      AuthService _authService = AuthService();
                      final exitoLog = await _authService.login(user, pass);
                      if (exitoLog){
                        context.go("/home", extra: tema);
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Algo esta mal en tu usuario o contraseña'))
                        );
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 250,
                      height: 75,
                      decoration: BoxDecoration(
                      color: Color(Utils.parseHex(tema.buttonColor)),
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white,
                            width: 5
                          )
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(tema.borderRadius.toDouble()))
                      ),
                      child: Text(
                        "Inciar Sesión",
                        style: TextStyle(
                          color: Color(Utils.parseHex(tema.neonColor))
                        )
                      )
                    ),
                  ),
                ],
              )
            ],
          )
        )
      ),
    );
  }
  
  InsertText(TemaConfig tema, String transparencia, Icon icon, String textoLabel, bool obscure,{required TextEditingController controller}) {
    Widget textLabel = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(width: 6),
          Text(
            textoLabel,
            style: TextStyle(
              color: Color(Utils.parseHex(tema.textColor))
            ),
          ),
        ],
      );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      width: 300,
      decoration: BoxDecoration(
        color: Color(Utils.parseHex(tema.neonColor, transparencia: transparencia),),
        border: Border.all(width: 2),
        borderRadius: BorderRadius.all(Radius.circular(tema.borderRadius.toDouble()))
      ),
      child: TextField(
        controller: controller,
        cursorOpacityAnimates: false,
        obscureText: obscure,
        decoration: InputDecoration(
          label: textLabel,
        ),    
      ),
    );
  }
}