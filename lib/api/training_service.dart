import 'package:apk_absen/api/endpoint/endpoint.dart';
import 'package:apk_absen/models/list_training_model.dart';
import 'package:apk_absen/preference/login.dart';
import 'package:http/http.dart' as http;

class TrainingService {
  /// Fetch semua training
  // UBAH RETURN TYPE DARI List<Datum> MENJADI List<TrainingData>
  static Future<List<TrainingData>> fetchtinemas() async {
    final url = Uri.parse(Endpoint.training);
    final token = await PreferenceHandler.getToken();

    final response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = listTrainingModelFromJson(response.body);
      return data.data ?? [];
    } else {
      throw Exception("Gagal load training (${response.statusCode})");
    }
  }
}
