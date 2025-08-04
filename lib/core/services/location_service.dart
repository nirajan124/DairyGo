import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  /// Check if location services are enabled
  static Future<bool> isLocationEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Request location permissions
  static Future<LocationPermission> requestPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return permission;
  }

  /// Get current location
  static Future<Position> getCurrentLocation() async {
    await requestPermissions();
    
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: Duration(seconds: 10),
    );
  }

  /// Get test location for development (emulator)
  static Future<Position> getTestLocation() async {
    // Return a test location (New York City)
    return Position(
      latitude: 40.7128,
      longitude: -74.0060,
      timestamp: DateTime.now(),
      accuracy: 10,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );
  }

  /// Get address from coordinates
  static Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return '${place.street}, ${place.locality}, ${place.administrativeArea}';
      }
      
      return 'Unknown Location';
    } catch (e) {
      print('Error getting address: $e');
      return 'Unknown Location';
    }
  }

  /// Get coordinates from address
  static Future<Position?> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      
      if (locations.isNotEmpty) {
        return Position(
          latitude: locations[0].latitude,
          longitude: locations[0].longitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
      }
      
      return null;
    } catch (e) {
      print('Error getting coordinates: $e');
      return null;
    }
  }

  /// Calculate distance between two points
  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  /// Check if location is within delivery radius
  static bool isWithinDeliveryRadius(
    double userLat, 
    double userLon, 
    double storeLat, 
    double storeLon, 
    double radiusKm
  ) {
    double distance = calculateDistance(userLat, userLon, storeLat, storeLon);
    return distance <= (radiusKm * 1000); // Convert km to meters
  }

  /// Get formatted distance string
  static String getFormattedDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)} m';
    } else {
      double km = distanceInMeters / 1000;
      return '${km.toStringAsFixed(1)} km';
    }
  }

  /// Check if running on emulator and use test location
  static Future<Position> getLocationForDevelopment() async {
    try {
      // Try to get real location first
      return await getCurrentLocation();
    } catch (e) {
      print('Using test location for development: $e');
      // Fall back to test location if real location fails
      return getTestLocation();
    }
  }
} 