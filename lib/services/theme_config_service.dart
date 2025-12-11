import 'dart:convert';

import 'package:tenis_pot3/models/theme_config_model.dart';
import 'package:http/http.dart';

class ThemeConfigService {


  String _END_POINT = "https://api-tenis-config-default-rtdb.europe-west1.firebasedatabase.app/Tema";

  Future<TemaConfig?> getTema(String menu) async {
    TemaConfig temaConfig;

    Uri uri = Uri.parse('${_END_POINT}/${menu}.json');

    Response response = await get(uri);

    if (response.statusCode != 200) return null;

    Map<String, dynamic> json = jsonDecode(response.body);

    temaConfig = TemaConfig.fromJson(json);

    return temaConfig;

  }
}