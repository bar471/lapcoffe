import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/takeaway_model.dart';

class LocationController {
  PositionModel? currentPosition;

  Future<String> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return 'Location service not enabled';
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return 'Location permission denied';
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return 'Location permission denied forever';
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      currentPosition = PositionModel(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      return currentPosition.toString();
    } catch (e) {
      return 'Gagal mendapatkan lokasi: $e';
    }
  }

  void openGoogleMaps() async {
    if (currentPosition != null) {
      final url =
          'https://www.google.com/maps?q=${currentPosition!.latitude},${currentPosition!.longitude}';
      await launchURL(url);
    }
  }

  Future<void> launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
