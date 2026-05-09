import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/guidemodel.dart';

class GuideService {
  static const String url = "http://165.22.243.199:8080/api/v1/guides";

  static Future<List<GuideModel>> fetchGuides() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List list = data['result'];

      return list.map((e) => GuideModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load guides");
    }
  }
}
