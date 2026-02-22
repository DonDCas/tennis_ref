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
}