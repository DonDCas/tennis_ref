import 'dart:convert';

PartidosResponse partidosResponseFromJson(String str) =>
    PartidosResponse.fromJson(json.decode(str));

String partidosResponseToJson(PartidosResponse data) =>
    json.encode(data.toJson());

class PartidosResponse {
  List<Partido> partidos;

  PartidosResponse({required this.partidos});

  factory PartidosResponse.fromJson(Map<String, dynamic> json) =>
      PartidosResponse(
        partidos: List<Partido>.from(
            json["partidos"].map((x) => Partido.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "partidos": List<dynamic>.from(partidos.map((x) => x.toJson())),
      };
}

class Partido {
  String? idPartido;
  String? id;
  String competicion;
  String fase;
  bool? isTieBreak;
  JugadorStats equipo1;
  JugadorStats equipo2;
  String? fechaJugado;
  dynamic ganador; // puede ser null o int

  Partido({
    this.idPartido,
    this.id,
    required this.competicion,
    required this.fase,
    required this.isTieBreak,
    required this.equipo1,
    required this.equipo2,
    this.fechaJugado,
    this.ganador,
  });

  factory Partido.fromJson(Map<String, dynamic> json) => Partido(
        idPartido: json["idPartido"],
        id: json["id"],
        competicion: json["competicion"],
        fase: json["fase"],
        isTieBreak: json["isTieBreak"],
        equipo1: JugadorStats.fromJson(json["equipo1"]),
        equipo2: JugadorStats.fromJson(json["equipo2"]),
        fechaJugado: json["fechaJugado"],
        ganador: json["ganador"],
      );

  Map<String, dynamic> toJson() => {
        "idPartido": idPartido,
        "id": id,
        "competicion": competicion,
        "fase": fase,
        "isTieBreak": isTieBreak,
        "equipo1": equipo1.toJson(),
        "equipo2": equipo2.toJson(),
        "fechaJugado": fechaJugado,
        "ganador": ganador,
      };
}

class JugadorStats {
  dynamic idJugador; // Puede ser int o String
  int sets;
  int juegos;
  int puntos;
  bool? saque;

  JugadorStats({
    required this.idJugador,
    required this.sets,
    required this.juegos,
    required this.puntos,
    this.saque,
  });

  factory JugadorStats.fromJson(Map<String, dynamic> json) => JugadorStats(
        idJugador: json["idJugador"],
        sets: json["sets"],
        juegos: json["juegos"],
        puntos: json["puntos"],
        saque: json["saque"],
      );

  Map<String, dynamic> toJson() => {
        "idJugador": idJugador,
        "sets": sets,
        "juegos": juegos,
        "puntos": puntos,
        "saque": saque,
      };
}
