import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getLocation() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error getting location: $e');
      rethrow;
    }
  }
}
