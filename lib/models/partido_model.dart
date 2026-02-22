import 'package:tennis_ref/Utils/utils.dart';
import 'package:tennis_ref/models/jugador_model.dart';

class Partido {
    String id;
    List<Participante> participantes;
    String estado;
    String competicion;
    String fase;
    int annio;
    String? fechaIniciado;
    String? fechaFinalizado;
    bool isTieBreak;
    DateTime creadoEn;
    int? arbitro;
    String? ganador;

    Partido({
        required this.id,
        required this.participantes,
        required this.estado,
        required this.competicion,
        required this.fase,
        required this.annio,
        this.fechaIniciado,
        this.fechaFinalizado,
        required this.isTieBreak,
        required this.creadoEn,
        this.arbitro,
        required this.ganador,
    });

    factory Partido.fromJson(Map<String, dynamic> json) => Partido(
        id: json["id"],
        participantes: List<Participante>.from(json["participantes"].map((x) => Participante.fromJson(x))) ?? [] ,
        estado: json["estado"],
        competicion: json["competicion"],
        fase: json["fase"],
        annio: json["annio"],
        fechaIniciado: json["fecha_iniciado"]?.toString() ?? 'No iniciado',
        fechaFinalizado: json["fecha_finalizado"]?.toString() ?? 'No finalizado',
        isTieBreak: json["is_tie_break"],
        creadoEn: DateTime.parse(json["creado_en"]),
        arbitro: json["arbitro"] ?? -1,
        ganador: json["ganador"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "participantes": List<dynamic>.from(participantes.map((x) => x.toJson())),
        "estado": estado,
        "competicion": competicion,
        "fase": fase,
        "annio": annio,
        "fecha_iniciado": fechaIniciado,
        "fecha_finalizado": (fechaFinalizado == 'No finalizado' || fechaFinalizado == '')
        ? null
        : fechaFinalizado,
        "is_tie_break": isTieBreak,
        "creado_en": creadoEn.toIso8601String(),
        "arbitro": arbitro,
        "ganador": (ganador == '')
        ? ""
        : ganador,
    };
}

class Participante {
    int id;
    String jugadorNombre;
    bool esJugador1;
    int sets1;
    int sets2;
    int sets3;
    bool saque;
    int puntos;
    String partido;
    String jugador;

    Participante({
        required this.id,
        required this.jugadorNombre,
        required this.esJugador1,
        required this.sets1,
        required this.sets2,
        required this.sets3,
        required this.saque,
        required this.puntos,
        required this.partido,
        required this.jugador,
    });

    factory Participante.fromJson(Map<String, dynamic> json) => Participante(
        id: json["id"],
        jugadorNombre: json["jugador_nombre"],
        esJugador1: json["es_jugador1"],
        sets1: json["sets_1"],
        sets2: json["sets_2"],
        sets3: json["sets_3"],
        saque: json["saque"],
        puntos: json["puntos"],
        partido: json["partido"],
        jugador: json["jugador"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "jugador_nombre": jugadorNombre,
        "es_jugador1": esJugador1,
        "sets_1": sets1,
        "sets_2": sets2,
        "sets_3": sets3,
        "saque": saque,
        "puntos": puntos,
        "partido": partido,
        "jugador": jugador,
    };
}