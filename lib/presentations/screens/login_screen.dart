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
  final TextEditingController regUserController = TextEditingController();
  final TextEditingController regEmailController = TextEditingController();
  final TextEditingController regPassController = TextEditingController();

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
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth > 600 ? 450 : screenWidth * 0.9;
    return Scaffold(
      backgroundColor: Color(Utils.parseHex(tema.primaryColor)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: containerWidth,
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
                  AutofillGroup(
                    child: Column(
                      children: [
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
                          controller: passController,

                        ),
                      ],
                    )
                  ),
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async{
                          final user = userController.text.trim();
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
                  ),
                  TextButton(
                    onPressed: () => _showRegisterSheet(context, tema, containerWidth),
                    child: Text(
                      "¿No tienes cuenta? Regístrate aquí",
                      style: TextStyle(
                        color: Color(Utils.parseHex(tema.textColor)).withOpacity(0.7),
                        decoration: TextDecoration.underline
                      ),
                    ),
                  )
                ],
              ),
            )
          ),
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

  void _showRegisterSheet(BuildContext context, TemaConfig tema, double width) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        width: width,
        decoration: BoxDecoration(
          color: Color(Utils.parseHex(tema.primaryColor)),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          border: Border.all(color: Color(Utils.parseHex(tema.neonColor)), width: 1),
        ),
        padding: EdgeInsets.only(
          top: 20, left: 20, right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20, 
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
             
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 20),
              Text("NUEVO REGISTRO", 
                style: TextStyle(color: Color(Utils.parseHex(tema.neonColor)), fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2)
              ),
              const SizedBox(height: 25),
             
              InsertText(tema, '33', const Icon(Icons.person_outline), 'Usuario', false, controller: regUserController),
              const SizedBox(height: 15),
              InsertText(tema, '33', const Icon(Icons.email_outlined), 'Correo electrónico', false, controller: regEmailController),
              const SizedBox(height: 15),
              InsertText(tema, '33', const Icon(Icons.lock_reset_outlined), 'Contraseña', true, controller: regPassController),
              
              const SizedBox(height: 30),

              _buildMainButton(
                text: "CREAR CUENTA",
                tema: tema,
                onTap: () async {
                  
                  final user = regUserController.text.trim();
                  final email = regEmailController.text.trim();
                  final pass = regPassController.text.trim();

                  if (user.isEmpty || email.isEmpty || pass.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Por favor, rellena todos los campos")));
                    return;
                  }
                  
                  if (await AuthService().registrar(user: user, email: email, pass: pass)){
                    if (context.mounted) Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('¡Usuario registrado con éxito! Ya puedes entrar.'),
                        backgroundColor: Colors.green,
                      )
                    );
                  }
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error al registrar. El usuario o email podrían estar en uso.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildMainButton({
    required String text,
    required TemaConfig tema,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 250,
        height: 75,
        decoration: BoxDecoration(
          color: Color(Utils.parseHex(tema.buttonColor)),
          border: const Border(
            bottom: BorderSide(
              color: Colors.white,
              width: 5, // Ese borde inferior que tenías originalmente
            ),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(tema.borderRadius.toDouble()),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Color(Utils.parseHex(tema.neonColor)),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}