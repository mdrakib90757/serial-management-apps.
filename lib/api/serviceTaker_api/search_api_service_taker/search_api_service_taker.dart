import 'package:SerialMan/core/api_client.dart';
import 'package:SerialMan/model/serviceCenter_model.dart';

class SearchApi {
  Future<List<ServiceCenterModel>> searchServiceCenters(
    String searchText,
  ) async {
    final Map<String, dynamic> queryParameters = {'searchText': searchText};

    try {
      final dynamic responseData = await ApiClient().get(
        '/serial-no/service-centers/search',
        queryParameters: queryParameters,
      );

      if (responseData is List) {
        return responseData
            .map((json) => ServiceCenterModel.fromJson(json))
            .toList();
      } else {
        throw Exception('API did not return a valid list');
      }
    } catch (e) {
      print('Error in SearchApi: $e');

      rethrow;
    }
  }
}
