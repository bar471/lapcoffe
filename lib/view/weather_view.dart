import 'package:flutter/material.dart';
import 'package:lapcoffee/controllers/weather_controller.dart'; // Import layanan cuaca yang telah Anda buat
import '../models/weather_model.dart'; // Import model cuaca

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherService _weatherService = WeatherService();
  late Future<Weather> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _weatherFuture = _weatherService
        .fetchWeather('Malang'); // Ganti dengan kota yang diinginkan
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Cuaca Terkini',
            style: TextStyle(color: Colors.white), // Set text color to white
          ),
          backgroundColor: const Color(0xFF6B4226),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                // Kembali ke halaman awal atau halaman login
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
          iconTheme: IconThemeData(color: Colors.white)),
      body: Center(
        child: FutureBuilder<Weather>(
          future: _weatherFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final weather = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Cuaca: ${weather.description}',
                      style: const TextStyle(fontSize: 20)),
                  Text('Suhu: ${weather.temperature}°C',
                      style: const TextStyle(fontSize: 20)),
                  Text('Terasa seperti: ${weather.feelsLike}°C',
                      style: const TextStyle(fontSize: 20)),
                ],
              );
            } else {
              return const Text('Tidak ada data cuaca');
            }
          },
        ),
      ),
    );
  }
}
