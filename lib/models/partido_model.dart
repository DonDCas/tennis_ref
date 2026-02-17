class Partido {
    String id;
    List<Participante> participantes;
    String estado;
    String competicion;
    String fase;
    int annio;
    DateTime fechaIniciado;
    dynamic fechaFinalizado;
    bool isTieBreak;
    DateTime creadoEn;
    String arbitro;
    String? ganador;

    Partido({
        required this.id,
        required this.participantes,
        required this.estado,
        required this.competicion,
        required this.fase,
        required this.annio,
        required this.fechaIniciado,
        required this.fechaFinalizado,
        required this.isTieBreak,
        required this.creadoEn,
        required this.arbitro,
        required this.ganador,
    });

    factory Partido.fromJson(Map<String, dynamic> json) => Partido(
        id: json["id"],
        participantes: List<Participante>.from(json["participantes"].map((x) => Participante.fromJson(x))),
        estado: json["estado"],
        competicion: json["competicion"],
        fase: json["fase"],
        annio: json["annio"],
        fechaIniciado: DateTime.parse(json["fecha_iniciado"]),
        fechaFinalizado: json["fecha_finalizado"],
        isTieBreak: json["is_tie_break"],
        creadoEn: DateTime.parse(json["creado_en"]),
        arbitro: json["arbitro"].toString(),
        ganador: json["ganador"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "participantes": List<dynamic>.from(participantes.map((x) => x.toJson())),
        "estado": estado,
        "competicion": competicion,
        "fase": fase,
        "annio": annio,
        "fecha_iniciado": fechaIniciado.toIso8601String(),
        "fecha_finalizado": fechaFinalizado,
        "is_tie_break": isTieBreak,
        "creado_en": creadoEn.toIso8601String(),
        "arbitro": arbitro,
        "ganador": ganador,
    };
}

class Participante {
    String id;
    String jugadorNombre;
    bool esJugador1;
    int sets1;
    int sets2;
    int sets3;
    bool saque;

    Participante({
        required this.id,
        required this.jugadorNombre,
        required this.esJugador1,
        required this.sets1,
        required this.sets2,
        required this.sets3,
        required this.saque,
    });

    factory Participante.fromJson(Map<String, dynamic> json) => Participante(
        id: json["jugador"],
        jugadorNombre: json["jugador_nombre"],
        esJugador1: json["es_jugador1"],
        sets1: json["sets_1"],
        sets2: json["sets_2"],
        sets3: json["sets_3"],
        saque: json["saque"],
    );

    Map<String, dynamic> toJson() => {
        "jugador": id,
        "jugador_nombre": jugadorNombre,
        "es_jugador1": esJugador1,
        "sets_1": sets1,
        "sets_2": sets2,
        "sets_3": sets3,
        "saque": saque,
    };
}
