import 'package:SerialMan/core/api_client.dart';
import 'package:SerialMan/model/division_model.dart';

class DivisionServiceCenter {
  Future<List<DivisionModel>> DivisionInfo() async {
    try {
      final response = await ApiClient().get('/locations/divisions');

      if (response is List) {
        return response
            .map((json) => DivisionModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else if (response is Map &&
          response['data'] != null &&
          response['data'] is List) {
        return (response['data'] as List)
            .map((json) => DivisionModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        print(
          'Unexpected response type for divisions: ${response.runtimeType}',
        );
        throw Exception('Failed to load divisions: Unexpected response format');
      }
    } catch (e) {
      print("Error fetching divisions: $e");
      rethrow;
    }
  }
}
