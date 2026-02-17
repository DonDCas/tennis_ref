// To parse this JSON data, do
//
//     final temaConfig = temaConfigFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

TemaConfig temaConfigFromJson(String str) => TemaConfig.fromJson(json.decode(str));

String temaConfigToJson(TemaConfig data) => json.encode(data.toJson());

class TemaConfig {
    
    int borderRadius;
    String buttonColor;
    String fontFamily;
    double glowIntensity;
    String neonColor;
    String primaryColor;
    String? tableRowColor;
    String textColor;
    String? gridColor;

    TemaConfig({
        required this.borderRadius,
        required this.buttonColor,
        required this.fontFamily,
        required this.glowIntensity,
        required this.neonColor,
        required this.primaryColor,
        this.tableRowColor,
        required this.textColor,
        this.gridColor,
    });

    factory TemaConfig.fromJson(Map<String, dynamic> json) => TemaConfig(
        borderRadius: json["borderRadius"],
        buttonColor: json["buttonColor"],
        fontFamily: json["fontFamily"],
        glowIntensity: json["glowIntensity"]?.toDouble(),
        neonColor: json["neonColor"],
        primaryColor: json["primaryColor"],
        tableRowColor: json["tableRowColor"],
        textColor: json["textColor"].toString(),
        gridColor: json["gridColor"],
    );

    Map<String, dynamic> toJson() => {
        "borderRadius": borderRadius,
        "buttonColor": buttonColor,
        "fontFamily": fontFamily,
        "glowIntensity": glowIntensity,
        "neonColor": neonColor,
        "primaryColor": primaryColor,
        "tableRowColor": tableRowColor,
        "textColor": textColor,
        "gridColor": gridColor,
    };
}

