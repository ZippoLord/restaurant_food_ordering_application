import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  // get current location
  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition();
  }

  // get address from coordinates
  static Future<String> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      Placemark place = placemarks[0];

      // Format the address
      String address = '';
      if (place.street != null && place.street!.isNotEmpty) {
        address += '${place.street}, ';
      }
      if (place.subLocality != null && place.subLocality!.isNotEmpty) {
        address += '${place.subLocality}, ';
      }
      if (place.locality != null && place.locality!.isNotEmpty) {
        address += '${place.locality}, ';
      }
      if (place.postalCode != null && place.postalCode!.isNotEmpty) {
        address += '${place.postalCode}, ';
      }
      if (place.country != null && place.country!.isNotEmpty) {
        address += place.country!;
      }

      return address;
    } catch (e) {
      return 'Unable to get address';
    }
  }
}
