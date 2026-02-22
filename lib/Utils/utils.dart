import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tennis_ref/models/jugador_model.dart';
import 'package:tennis_ref/models/partido_model.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static int parseHex(String numHex, {String transparencia = 'FF'}) {
    String hexColor = numHex.replaceAll("#", "");
    return int.parse('$transparencia$hexColor', radix: 16);
  }

  //Metodo que transforma un String que contenga una fecha en un DateTime obviando las horas
  static DateTime StringtoDateTime(String fecha){
    List<String> fechaChopeada = fecha.split("/");
    String fechaEnFormatoDateTime = '${fechaChopeada[2]}-${fechaChopeada[1]}-${fechaChopeada[0]}';
    return DateTime.parse(fechaEnFormatoDateTime);
  }

//Metodo que transforma una fecha en formato DateTime en String con formato (dd/MM/yyyy) obviando las horas.
  static String DateTimeToString(DateTime fecha) {
    final day = fecha.day.toString().padLeft(2, '0');
    final month = fecha.month.toString().padLeft(2, '0');
    final year = fecha.year.toString();
    return '$day/$month/$year';
  }

  static String formatFechaString(String fecha){
    List<String> fechaChopeada = fecha.split('T')[0].split('-');
    return "${fechaChopeada[2]}/${fechaChopeada[1]}/${fechaChopeada[0]}";
  }

  static String conversorFase(String puntos) {
    return switch(puntos){
      "0" => "Amistoso",
      "1" => "Final",
      "2" => "Semi-Final",
      "3" => "Cuartos de final",
      "4" => "Octavos de final",
      "5" => "Dieciseisavos de final",
      "6" => "2ª Ronda",
      "7" => "1ª Ronda",
      "8" => "Fase Previa",
      _ => "ERROR"
    };
  }
  static Future<void> exportarPartidoCSV(Partido partido, Jugador j1, Jugador j2) async {
    // 1. Crear el contenido del CSV
    String csvData = "Competicion;Fase;Ganador;Jugador 1;Pais 1;S1 J1;S2 J1;S3 J1;Jugador 2;Pais 2;S1 J2;S2 J2;S3 J2\n";
    
    csvData += "${partido.competicion};"
               "${partido.fase};"
               "${partido.ganador};"
               "${j1.nombreCompleto};"
               "${j1.pais};"
               "${partido.participantes[0].sets1};"
               "${partido.participantes[0].sets2};"
               "${partido.participantes[0].sets3};"
               "${j2.nombreCompleto};"
               "${j2.pais};"
               "${partido.participantes[1].sets1};"
               "${partido.participantes[1].sets2};"
               "${partido.participantes[1].sets3}";
    if (kIsWeb) {
      final Uri uri = Uri.dataFromString(
        csvData,
        mimeType: 'text/csv',
        encoding: utf8,
      );
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } else {
      try {
        final directory = await getTemporaryDirectory();
        final path = "${directory.path}/partido_${partido.id}.csv";
        final file = File(path);

        await file.writeAsString(csvData);

        await Share.shareXFiles(
          [XFile(path)],
          text: 'Informe del partido: ${j1.nombreCompleto} vs ${j2.nombreCompleto}',
        );
      } catch (e) {
        print("Error al exportar CSV: $e");
      }
    }
  }
}