import 'dart:convert';

class Partido {
  String? idPartido;
  String? id;
  String competicion;
  String fase;
  bool? isTieBreak;
  JugadorStats equipo1;
  JugadorStats equipo2;
  String? fechaJugado;
  dynamic ganador;

  // Sets individuales como listas
  List<int> sets_e1;
  List<int> sets_e2;
  List<String?> sets_ganadores; // cada posición puede ser null o el id del ganador del set

  Partido({
    this.idPartido,
    this.id,
    required this.competicion,
    required this.fase,
    this.isTieBreak,
    required this.equipo1,
    required this.equipo2,
    this.fechaJugado,
    this.ganador,
    required this.sets_e1,
    required this.sets_e2,
    required this.sets_ganadores,
  });

  // Función auxiliar para parsear listas de enteros de forma segura
  static List<int> _parseIntList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => (e ?? 0) as int).toList();
    }
    return [];
  }

  factory Partido.fromJson(Map<String, dynamic> json) {
    final setsE1 = _parseIntList(json["sets_e1"]);
    final setsE2 = _parseIntList(json["sets_e2"]);

    final equipo1 = JugadorStats(
      idJugador: json["equipo1_id"],
      sets: setsE1.isNotEmpty ? setsE1.reduce((a, b) => a + b) : 0,
      juegos: json["game_e1"] ?? json["equipo1_juegos"] ?? 0,
      puntos: json["puntos_e1"] ?? json["equipo1_puntos"] ?? 0,
      saque: json["equipo1_saque"],
    );

    final equipo2 = JugadorStats(
      idJugador: json["equipo2_id"],
      sets: setsE2.isNotEmpty ? setsE2.reduce((a, b) => a + b) : 0,
      juegos: json["game_e2"] ?? json["equipo2_juegos"] ?? 0,
      puntos: json["puntos_e2"] ?? json["equipo2_puntos"] ?? 0,
      saque: json["equipo2_saque"],
    );

    return Partido(
      id: json["id"],
      competicion: json["competicion"],
      fase: json["fase"],
      isTieBreak: json["is_tiebreak"],
      equipo1: equipo1,
      equipo2: equipo2,
      fechaJugado: json["fechajugado"],
      ganador: json["ganador_id"],
      sets_e1: setsE1.isNotEmpty ? setsE1 : [0, 0, 0],
      sets_e2: setsE2.isNotEmpty ? setsE2 : [0, 0, 0],
      sets_ganadores: (json["sets_ganadores"] != null && json["sets_ganadores"] is List)
          ? List<String?>.from(json["sets_ganadores"])
          : [null, null, null],
    );
  }

  Map<String, dynamic> toJson() => {
      // Datos generales
      "competicion": competicion,
      "fase": fase,
      "fechajugado": fechaJugado,
      
      // IDs de los jugadores
      "equipo1_id": equipo1.idJugador,
      "equipo2_id": equipo2.idJugador,
      
      // Sets por set
      "set1_e1": sets_e1.length > 0 ? sets_e1[0] : 0,
      "set1_e2": sets_e2.length > 0 ? sets_e2[0] : 0,
      "set2_e1": sets_e1.length > 1 ? sets_e1[1] : 0,
      "set2_e2": sets_e2.length > 1 ? sets_e2[1] : 0,
      "set3_e1": sets_e1.length > 2 ? sets_e1[2] : 0,
      "set3_e2": sets_e2.length > 2 ? sets_e2[2] : 0,

      // Ganadores de cada set
      "set1_ganador": sets_ganadores.length > 0 ? sets_ganadores[0] : null,
      "set2_ganador": sets_ganadores.length > 1 ? sets_ganadores[1] : null,
      "set3_ganador": sets_ganadores.length > 2 ? sets_ganadores[2] : null,
      
      // Totales
      "sets_e1": equipo1.sets,
      "sets_e2": equipo2.sets,
      
      // Juegos y puntos actuales
      "game_e1": equipo1.juegos,
      "game_e2": equipo2.juegos,
      "puntos_e1": equipo1.puntos,
      "puntos_e2": equipo2.puntos,
      
      // Otros
      "is_tiebreak": isTieBreak,
      "ganador_id": ganador,
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
