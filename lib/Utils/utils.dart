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
}