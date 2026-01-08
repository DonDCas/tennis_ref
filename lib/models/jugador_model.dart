// To parse this JSON data, do
//
//     final jugador = jugadorFromJson(jsonString);

import 'dart:convert';

List<Jugador> jugadorFromJson(String str) => List<Jugador>.from(json.decode(str).map((x) => Jugador.fromJson(x)));

String jugadorToJson(List<Jugador> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Jugador {
    String id;
    String nombreCompleto;
    String pais;
    dynamic bandera;
    dynamic fechaNacimiento;
    int rankingAtp;
    int mejorRanking;
    String manoDominante;
    String foto;
    DateTime creacion;
    DateTime actualizacion;

    Jugador({
        required this.id,
        required this.nombreCompleto,
        required this.pais,
        required this.bandera,
        required this.fechaNacimiento,
        required this.rankingAtp,
        required this.mejorRanking,
        required this.manoDominante,
        required this.foto,
        required this.creacion,
        required this.actualizacion,
    });

    factory Jugador.fromJson(Map<String, dynamic> json) => Jugador(
        id: json["id"],
        nombreCompleto: json["nombre_completo"],
        pais: json["pais"],
        bandera: json["bandera"],
        fechaNacimiento: json["fecha_nacimiento"],
        rankingAtp: json["ranking_atp"],
        mejorRanking: json["mejor_ranking"],
        manoDominante: json["mano_dominante"],
        foto: json["foto"],
        creacion: DateTime.parse(json["creacion"]),
        actualizacion: DateTime.parse(json["actualizacion"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre_completo": nombreCompleto,
        "pais": pais,
        "bandera": bandera,
        "fecha_nacimiento": fechaNacimiento,
        "ranking_atp": rankingAtp,
        "mejor_ranking": mejorRanking,
        "mano_dominante": manoDominante,
        "foto": foto,
        "creacion": creacion.toIso8601String(),
        "actualizacion": actualizacion.toIso8601String(),
    };
}
