// To parse this JSON data, do
//
//     final jugadorResponse = jugadorResponseFromJson(jsonString);

import 'dart:convert';

import 'package:tenis_pot3/models/jugador_model.dart';

JugadorResponse jugadorResponseFromJson(String str) => JugadorResponse.fromJson(json.decode(str));

String jugadorResponseToJson(JugadorResponse data) => json.encode(data.toJson());

class JugadorResponse {
    int count;
    String next;
    dynamic previous;
    List<Jugador> results;

    JugadorResponse({
        required this.count,
        required this.next,
        required this.previous,
        required this.results,
    });

    factory JugadorResponse.fromJson(Map<String, dynamic> json) => JugadorResponse(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<Jugador>.from(json["results"].map((x) => Jugador.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
    };
}



