import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tenis_pot3/services/jugador_service.dart';
import 'package:intl/intl.dart';


class CrearJugadorSheet extends StatefulWidget {
  
  const CrearJugadorSheet({super.key});

  @override
  State<CrearJugadorSheet> createState() => _CrearJugadorSheetState();
}

class _CrearJugadorSheetState extends State<CrearJugadorSheet> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _nacionalidadController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  DateTime? _fechaNacimiento;
  String? _mDominante;
  File? _image;


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Crear Jugador",
                style: GoogleFonts.getFont(
                  "Orbitron",
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 12,),
              _input(
                controller : _nombreController,
                label: "Nombre Completo",
                validator: (v) => (v == null || v.isEmpty ? "Campo Obligatorio" : null)
              ),
              SizedBox(height: 12,),
              _input(
                controller : _nacionalidadController,
                label: "Nacionalidad del jugador",
                validator: (v) => (v == null || v.isEmpty ? "Campo Obligatorio" : null)
              ),
              SizedBox(height: 12,),
              GestureDetector(
                onTap: () => _seleccionarFecha(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Fecha de nacimiento',
                      suffixIcon: Icon(Icons.calendar_today)
                    ),
                    validator: (_) => _fechaNacimiento==null ? "Selecciona una fecha" : null,
                    controller: TextEditingController(
                      text: _fechaNacimiento == null
                        ? ''
                        : DateFormat('dd/MM/yyyy').format(_fechaNacimiento!),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Mano Dominante',
                    style: GoogleFonts.getFont(
                      'Orbitron',
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  RadioListTile<String>(
                    title: Text('Derecha'),
                    value: 'D',
                    groupValue: _mDominante,
                    onChanged: (value){
                      setState(() {
                        _mDominante = value;
                      });
                    }
                  ),
                  RadioListTile<String>(
                    title: Text('Izquierda'),
                    value: 'Z',
                    groupValue: _mDominante,
                    onChanged: (value){
                      setState(() {
                        _mDominante = value;
                      });
                    }
                  ),
                ],
              ),
              SizedBox(height: 12,),
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                    ? Icon(Icons.camera_alt, size: 40)
                    : null,
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _guardar, 
                  child: Text("Guardar"),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String)? validator,
  }){
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      //validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(), 
      )
    );
  }
  void _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    if (_mDominante == null){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selecciona la mano dominante')),
      );
      return;
    }
    final jugadorService  = JugadorService();

    final jugador = await jugadorService.crearJugador(
      nombreCompleto: _nombreController.text,
      pais: _nacionalidadController.text,
      fechaNacimiento: _fechaNacimiento!.toIso8601String(),
      rankingAtp: 0,
      mejorRanking: 0,
      manoDominante: _mDominante!,
      image: _image,
    );
    if (jugador != null){
      Navigator.pop(context, jugador);
    }
  }
  Future<void> _seleccionarFecha(BuildContext context) async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now()
    );
    if (fecha != null) {
      setState((){
        _fechaNacimiento = fecha;
      });
    }
  }

  Future<void> pickImage() async{
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null){
      setState(() {
        _image = File(image.path);
      });
    }
  }
}
