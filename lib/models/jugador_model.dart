// To parse this JSON data, do
//
//     final jugador = jugadorFromJson(jsonString);

import 'dart:convert';

Jugador jugadorFromJson(String str) => Jugador.fromJson(json.decode(str));

String jugadorToJson(Jugador data) => json.encode(data.toJson());

class Jugador {

    String? idJugador;
    String nombre;
    String nacionalidad;
    String foto;

    Jugador({
        this.idJugador,
        required this.nombre,
        required this.nacionalidad,
        required this.foto,
    });

    factory Jugador.fromJson(Map<String, dynamic> json) => Jugador(
        idJugador: json["idJugador"],
        nombre: json["nombre"],
        nacionalidad: json["nacionalidad"],
        foto: json["foto"],
        
    );

    Map<String, dynamic> toJson() => {
        "idJugador": idJugador,
        "nombre": nombre,
        "nacionalidad": nacionalidad,
        "foto": foto,
    };
}
