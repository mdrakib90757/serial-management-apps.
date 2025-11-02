import 'dart:convert';

import 'package:SerialMan/core/api_client.dart';
import 'package:SerialMan/model/serialService_model.dart';

import '../../../request_model/serviceCanter_request/next_button_request/next_button_request.dart';

class NextButtonService {
  Future<dynamic> nextButton(
    String serviceCenterId,
    NextButtonRequest request,
  ) async {
    try {
      String body = jsonEncode(request.toJson());
      var response = await ApiClient().post(
        "/serial-no/service-centers/$serviceCenterId/services/next",
        body: body,
      );

      return response;
    } catch (e) {
      print("Error triggering next action: $e");
      throw Exception("Failed to trigger next action: $e");
    }
  }

  Future<List<SerialModel>> getNextButton(
    String serviceCenterId,
    String date,
  ) async {
    try {
      final Map<String, String> queryParameters = {'date': date};
      var response =
          await ApiClient().get(
                "/serial-no/service-centers/$serviceCenterId/services",
                queryParameters: queryParameters,
              )
              as List;
      List<SerialModel> NewButtonData = response
          .map((data) => SerialModel.fromJson(data))
          .toList();
      return NewButtonData;
    } catch (e) {
      print("Error fetching or parsing NewButtonData - : $e");
      return [];
    }
  }
}
