import 'dart:convert';

import 'package:SerialMan/core/api_client.dart';

import '../../../../model/serialService_model.dart';
import '../../../../request_model/serviceCanter_request/newSerialButton_request/queue_edit_list_request/queue_edit_list_request.dart';

class QueueListEditService {
  Future<dynamic> QueueListEdit(
    queueEditListRequest queueListEditRequest,
    String serviceCenterId,
    String id,
  ) async {
    String body = jsonEncode(queueListEditRequest.toJson());
    final response = ApiClient().put(
      "/serial-no/service-centers/$serviceCenterId/services/$id",
      body: body,
    );
    return response;
  }

  Future<List<SerialModel>> getNewSerialButton(
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
