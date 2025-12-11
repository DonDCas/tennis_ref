// To parse this JSON data, do
//
//     final jugador = jugadorFromJson(jsonString);

import 'dart:convert';

Jugador jugadorFromJson(String str) => Jugador.fromJson(json.decode(str));

String jugadorToJson(Jugador data) => json.encode(data.toJson());

class Jugador {

    String? idJugador;
    String nombre;
    String alias;
    String foto;

    Jugador({
        this.idJugador,
        required this.nombre,
        required this.alias,
        required this.foto,
    });

    factory Jugador.fromJson(Map<String, dynamic> json) => Jugador(
        idJugador: json["idJugador"],
        nombre: json["nombre"],
        alias: json["alias"],
        foto: json["foto"],
        
    );

    Map<String, dynamic> toJson() => {
        "idJugador": idJugador,
        "nombre": nombre,
        "alias": alias,
        "foto": foto,
    };
}
