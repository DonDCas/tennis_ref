// To parse this JSON data, do
//
//     final partidoResponse = partidoResponseFromJson(jsonString);

import 'dart:convert';

import 'package:tennis_ref/models/partido_model.dart';

PartidoResponse partidoResponseFromJson(String str, Map<String, String> queryParameters) => PartidoResponse.fromJson(json.decode(str));

String partidoResponseToJson(PartidoResponse data) => json.encode(data.toJson());

class PartidoResponse {
    int count;
    dynamic next;
    dynamic previous;
    List<Partido> results;

    PartidoResponse({
        required this.count,
        required this.next,
        required this.previous,
        required this.results,
    });

    factory PartidoResponse.fromJson(Map<String, dynamic> json) => PartidoResponse(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<Partido>.from(json["results"].map((x) => Partido.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
    };
}
