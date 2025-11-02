import 'dart:convert';

import 'package:SerialMan/core/api_client.dart';
import 'package:SerialMan/model/serialService_model.dart';
import 'package:SerialMan/request_model/serviceCanter_request/status_UpdateButtonRequest/status_updateButtonRequest.dart';

import '../../../request_model/serviceCanter_request/next_button_request/next_button_request.dart';

class StatusUpdateButtonService {
  Future<dynamic> statusButton(
    StatusButtonRequest statusRequest,
    String serviceCenterId,
    String serviceId,
  ) async {
    String body = jsonEncode(statusRequest.toJson());
    final response = await ApiClient().put(
      "/serial-no/service-centers/$serviceCenterId/services/$serviceId",
      body: body,
    );
    return response;
  }

  Future<List<SerialModel>> GetStatusButtonService(
    String serviceCenterId,
    String? date,
  ) async {
    try {
      final Map<String, String> queryParameters = {
        'date': date?.toString() ?? '',
      };
      var response =
          await ApiClient().get(
                "/serial-no/service-centers/$serviceCenterId/services",
                queryParameters: queryParameters,
              )
              as List;
      List<SerialModel> StatusButtonData = response
          .map((data) => SerialModel.fromJson(data as Map<String, dynamic>))
          .toList();
      return StatusButtonData;
    } catch (e) {
      print("Error fetching or parsing GetEditButton - : $e");
      return [];
    }
  }
}
