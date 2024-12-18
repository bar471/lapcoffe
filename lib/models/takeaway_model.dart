class PositionModel {
  final double latitude;
  final double longitude;

  PositionModel({required this.latitude, required this.longitude});

  @override
  String toString() {
    return 'Lat: $latitude, Long: $longitude';
  }
}
