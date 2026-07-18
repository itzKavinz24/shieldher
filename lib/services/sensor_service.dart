import 'dart:convert';
import 'package:http/http.dart' as http;

class SensorService {
  static Future<Map<String, dynamic>>
      getSensorData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://192.168.1.2:5000/sensor',
        ),
      );

      print(
        "STATUS CODE = ${response.statusCode}",
      );

      print(
        "RESPONSE = ${response.body}",
      );
      

      if (response.statusCode == 200) {
        final json =
            jsonDecode(response.body);

        if (json['data'] != null) {
          return json['data'];
        }

        return json;
      }

      return {
        "heartRate": 75,
        "stress": 20,
        "riskLevel": "LOW",
      };
    } catch (e) {
      print(
        "SENSOR ERROR = $e",
      );

      return {
        "heartRate": 75,
        "stress": 20,
        "riskLevel": "LOW",
      };
    }
  }
}