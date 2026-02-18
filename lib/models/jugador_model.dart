// To parse this JSON data, do
//
//     final jugador = jugadorFromJson(jsonString);

import 'dart:convert';

Jugador jugadorFromJson(String str) => Jugador.fromJson(json.decode(str));

String jugadorToJson(Jugador data) => json.encode(data.toJson());

class Jugador {
    String? id;
    String nombreCompleto;
    String pais;
    dynamic bandera;
    DateTime fechaNacimiento;
    int rankingAtp;
    int mejorRanking;
    String manoDominante;
    String foto;
    DateTime creacion;
    DateTime actualizacion;

    Jugador({
        this.id,
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

    factory Jugador.fromJson(Map<String, dynamic> json) {
  return Jugador(
    id: json["id"]?.toString(), 
    nombreCompleto: json["nombre_completo"] ?? "Sin nombre",
    pais: json["pais"] ?? "Sin país",
    bandera: json["bandera"] ?? "",
    
    // Protección para fecha_nacimiento
    fechaNacimiento: json["fecha_nacimiento"] != null 
        ? DateTime.parse(json["fecha_nacimiento"]) 
        : DateTime(2000, 1, 1),
        
    rankingAtp: json["ranking_atp"] ?? 0,
    mejorRanking: json["mejor_ranking"] ?? 0,
    manoDominante: json["mano_dominante"] ?? "D",
    
    // Protección para el error de List<dynamic> en la foto
    foto: (json["foto"] is List) 
        ? json["foto"][0].toString() 
        : (json["foto"]?.toString() ?? ""),
    
    // Protección para creación y actualización
    creacion: json["creacion"] != null 
        ? DateTime.parse(json["creacion"]) 
        : DateTime.now(),
        
    actualizacion: json["actualizacion"] != null 
        ? DateTime.parse(json["actualizacion"]) 
        : DateTime.now(),
  );
}

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre_completo": nombreCompleto,
        "pais": pais,
        "bandera": bandera,
        "fecha_nacimiento": "${fechaNacimiento.year.toString().padLeft(4, '0')}-${fechaNacimiento.month.toString().padLeft(2, '0')}-${fechaNacimiento.day.toString().padLeft(2, '0')}",
        "ranking_atp": rankingAtp,
        "mejor_ranking": mejorRanking,
        "mano_dominante": manoDominante,
        "foto": foto,
        "creacion": creacion.toIso8601String(),
        "actualizacion": actualizacion.toIso8601String(),
    };
}
