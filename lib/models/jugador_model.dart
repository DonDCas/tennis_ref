class Jugador {
    String id;
    String nombreCompleto;
    String pais;
    String bandera;
    DateTime fechaNacimiento;
    int rankingAtp;
    int mejorRanking;
    ManoDominante manoDominante;
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
        fechaNacimiento: DateTime.parse(json["fecha_nacimiento"]),
        rankingAtp: json["ranking_atp"],
        mejorRanking: json["mejor_ranking"],
        manoDominante: manoDominanteValues.map[json["mano_dominante"]]!,
        foto: json["foto"],
        creacion: DateTime.parse(json["creacion"]),
        actualizacion: DateTime.parse(json["actualizacion"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre_completo": nombreCompleto,
        "pais": pais,
        "bandera": bandera,
        "fecha_nacimiento": "${fechaNacimiento.year.toString().padLeft(4, '0')}-${fechaNacimiento.month.toString().padLeft(2, '0')}-${fechaNacimiento.day.toString().padLeft(2, '0')}",
        "ranking_atp": rankingAtp,
        "mejor_ranking": mejorRanking,
        "mano_dominante": manoDominanteValues.reverse[manoDominante],
        "foto": foto,
        "creacion": creacion.toIso8601String(),
        "actualizacion": actualizacion.toIso8601String(),
    };
}

enum ManoDominante {
    D,
    Z
}

final manoDominanteValues = EnumValues({
    "D": ManoDominante.D,
    "Z": ManoDominante.Z
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}