import 'dart:convert';

import 'package:SerialMan/core/api_client.dart';
import 'package:SerialMan/model/serviceCenter_model.dart';
import 'package:SerialMan/request_model/serviceCanter_request/addButton_request/add_Button_request.dart';

class AddButtonApi {
  final ApiClient _apiClient = ApiClient();

  //AddButton
  Future<dynamic> addButton_service(
    AddButtonRequest requestData,
    String companyId,
  ) async {
    String body = jsonEncode(requestData.toJson());
    final response = ApiClient().post(
      "/serial-no/companies/$companyId/service-centers",
      body: body,
    );
    return response;
  }

  //Get AddButton
  Future<List<ServiceCenterModel>> GetAddButton(String companyId) async {
    try {
      var response =
          await ApiClient().get(
                "/serial-no/companies/$companyId/service-centers",
              )
              as List;
      List<ServiceCenterModel> ButtonData = response
          .map(
            (data) => ServiceCenterModel.fromJson(data as Map<String, dynamic>),
          )
          .toList();
      return ButtonData;
    } catch (e) {
      print("Error fetching or parsing GetAddButton - : $e");
      return [];
    }
  }

  Future<bool> deleteServiceCenter({
    required String companyId,
    required String serviceCenterId,
  }) async {
    final String endpoint =
        "/serial-no/companies/$companyId/service-centers/$serviceCenterId";

    return await _apiClient.delete(endpoint);
  }
}
