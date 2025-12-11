class Utils {
  static int parseHex(String numHex) {
    String hexColor = numHex.replaceAll("#", "");
    return int.parse('FF$hexColor', radix: 16);
  }
}