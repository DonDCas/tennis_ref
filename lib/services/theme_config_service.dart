import 'dart:convert';

import 'package:tennis_ref/models/theme_config_model.dart';
import 'package:http/http.dart';

class ThemeConfigService {
  final String _END_POINT =
      "https://api-tenis-config-default-rtdb.europe-west1.firebasedatabase.app/Tema";

  Future<TemaConfig?> getTema(String key) async {
    final uri = Uri.parse('$_END_POINT/$key.json');
    print("Caca");
    print(uri);


    final response = await get(uri);

    print(response.body);

    if (response.body == 'null') return null;

    final Map<String, dynamic> 
    jsonMap =
        jsonDecode(response.body) as Map<String, dynamic>;

    return TemaConfig.fromJson(jsonMap);
  }
}
