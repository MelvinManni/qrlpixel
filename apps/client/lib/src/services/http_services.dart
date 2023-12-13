import 'package:client/src/services/json_services.dart';
import 'package:http/http.dart' as http;

class HTTPServices {
  static get(String url, {String? token}) async {
    return http.get(Uri.parse(url), headers: {
      "authorization": "Bearer $token",
    });
  }

  static post(String url, {Map<String, dynamic>? body, String? token}) async {
    return http.post(
      Uri.parse(url),
      headers: {
        "authorization": "Bearer $token",
        "content-type": "application/json"
      },
      body: JSONServices.encode(body ?? {}),
    );
  }
}
