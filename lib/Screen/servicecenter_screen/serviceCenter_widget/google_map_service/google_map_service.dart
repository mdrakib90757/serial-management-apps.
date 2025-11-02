import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class Suggestion {
  final String placeId;
  final String description;
  final String? locationName;
  Suggestion(this.placeId, this.description, this.locationName);

  @override
  String toString() {
    return locationName ?? description;
  }
}

class GoogleMapsService {
  final String _apiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;
  Future<List<Suggestion>> fetchSuggestions(String input) async {
    if (input.isEmpty) {
      return [];
    }
    const sessionToken = '1234567890';
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json'
        '?input=$input'
        '&key=$_apiKey'
        '&sessiontoken=$sessionToken'
        '&components=country:bd';

    try {
      final response = await http.get(Uri.parse(request));

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['status'] == 'OK') {
          return result['predictions']
              .map<Suggestion>(
                (p) => Suggestion(
                  p['place_id'],
                  p['description'],
                  p['structured_formatting']?['main_text'],
                ),
              )
              .toList();
        }
        print(
          "Places API Error: ${result['error_message'] ?? result['status']}",
        );
      }
    } catch (e) {
      print("Error fetching suggestions: $e");
    }
    return [];
  }

  Future<LatLng> getLatLngFromPlaceId(String placeId) async {
    final request =
        'https://maps.googleapis.com/maps/api/geocode/json'
        '?place_id=$placeId'
        '&key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(request));

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['status'] == 'OK') {
          final location = result['results'][0]['geometry']['location'];
          return LatLng(location['lat'], location['lng']);
        }
      }
    } catch (e) {
      print("Error getting LatLng from Place ID: $e");
    }

    throw Exception('Failed to get coordinates from place ID');
  }

  Future<Suggestion?> getPlaceDetailsFromLatLng(LatLng position) async {
    final request =
        'https://maps.googleapis.com/maps/api/geocode/json'
        '?latlng=${position.latitude},${position.longitude}'
        '&key=$_apiKey';
    try {
      final response = await http.get(Uri.parse(request));
      print("API Response: ${response.body}");

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['status'] == 'OK' && result['results'].isNotEmpty) {
          final place = result['results'][0];

          return Suggestion(
            place['place_id'],
            place['formatted_address'],
            place['address_components']?[0]?['long_name'],
          );
        }
      }
    } catch (e) {
      print("Error in Reverse Geocoding: $e");
    }

    return null;
  }
}
