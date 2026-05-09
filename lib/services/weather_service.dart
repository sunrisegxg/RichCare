import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const apiKey = "89a2531d8db6cc4e60a02d6bf12847f6";

  Future<Map<String, dynamic>?> getWeather(double lat, double lon) async {
    final url =
        "https://api.openweathermap.org/data/2.5/weather"
        "?lat=$lat&lon=$lon"
        "&appid=$apiKey&units=metric";

    final res = await http.get(Uri.parse(url));

    print(res.body);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      // 🌧 FIX RAIN luôn tại đây
      data['rain_mm'] = _parseRain(data);

      return data;
    }

    return null;
  }

  // 🔥 helper xử lý rain
  double _parseRain(Map<String, dynamic> json) {
    final rain = json['rain'];

    if (rain == null) return 0.0;

    return ((rain['1h'] ?? rain['3h'] ?? 0) as num).toDouble();
  }
}
