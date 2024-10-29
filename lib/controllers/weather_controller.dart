import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lapcoffee/models/weather_model.dart';

class WeatherService {
  final String apiKey = '3c6699065807df0fe836a1d0ef890772'; // Ganti dengan API key Anda
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> fetchWeather(String city) async {
    final response = await http.get(
      Uri.parse('$baseUrl?q=$city&units=metric&appid=$apiKey'),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Weather.fromJson(json);
    } else {
      throw Exception('Failed to load weather');
    }
  }
}
