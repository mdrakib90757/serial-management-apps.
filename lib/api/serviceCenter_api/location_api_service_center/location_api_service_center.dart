import 'package:SerialMan/model/company_details_model.dart';
import '../../../core/api_client.dart';

class LocationService {
  final ApiClient _apiClient = ApiClient();

  Future<List<LocationPart>> fetchDivisions() async {
    try {
      final response = await _apiClient.get("/locations/divisions");
      if (response is List) {
        return response.map((json) => LocationPart.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load divisions: Unexpected response format");
      }
    } catch (e) {
      print("Error fetching divisions: $e");
      throw Exception("Error fetching divisions");
    }
  }

  Future<List<LocationPart>> fetchDistricts(int divisionId) async {
    try {
      final response = await _apiClient.get(
        "/locations/districts",
        queryParameters: {'divisionId': divisionId.toString()},
      );
      if (response is List) {
        return response.map((json) => LocationPart.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load districts");
      }
    } catch (e) {
      throw Exception("Error fetching districts");
    }
  }

  Future<List<LocationPart>> fetchThanas(int districtId) async {
    try {
      final response = await _apiClient.get(
        "/locations/thanas",
        queryParameters: {'districtId': districtId.toString()},
      );
      if (response is List) {
        return response.map((json) => LocationPart.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load thanas");
      }
    } catch (e) {
      throw Exception("Error fetching thanas");
    }
  }

  Future<List<LocationPart>> fetchAreas(int thanaId) async {
    try {
      final response = await _apiClient.get(
        "/locations/areas",
        queryParameters: {'thanaId': thanaId.toString()},
      );
      if (response is List) {
        return response.map((json) => LocationPart.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load areas");
      }
    } catch (e) {
      throw Exception("Error fetching areas");
    }
  }
}
