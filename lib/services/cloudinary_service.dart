import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class CloudinaryService {
  static const cloudName = "du6casvsc";
  static const uploadPreset = "rice_care";

  static Future<String> uploadImage(String base64Image) async {
    final bytes = base64Decode(base64Image);

    final tempDir = await getTemporaryDirectory();

    final file = File('${tempDir.path}/upload.png');

    await file.writeAsBytes(bytes);

    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    final request = http.MultipartRequest("POST", url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath("file", file.path));

    final response = await request.send();

    final responseData = await response.stream.bytesToString();

    log(responseData);

    final data = jsonDecode(responseData);

    return data["secure_url"] ?? "";
  }
}
