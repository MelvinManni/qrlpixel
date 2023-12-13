import 'dart:convert';

class JSONServices {
  static dynamic decode(Object? parameter) {
    if (parameter is String) {
      return jsonDecode(parameter);
    } else {
      return parameter;
    }
  }

  static String encode(dynamic jsonObject) {
    return json.encode(jsonObject);
  }
}
