import 'dart:convert';

import 'package:SerialMan/model/serialService_model.dart';
import 'package:SerialMan/request_model/serviceCanter_request/addButton_serviceType_request/addButtonServiceType_request.dart';
import '../../../core/api_client.dart';
import '../../../model/service_type_model.dart';

class AddButtonServiceType {
  final ApiClient _apiClient = ApiClient();

  //AddButton
  Future<dynamic> addButton_serviceType(
    AddButtonServiceTypeRequest requestData,
    String companyId,
  ) async {
    String body = jsonEncode(requestData.toJson());
    final response = ApiClient().post(
      "/serial-no/companies/$companyId/service-types",
      body: body,
    );
    return response;
  }

  //Get AddButton
  Future<List<serviceTypeModel>> getAddButtonServiceType(
    String companyId,
  ) async {
    try {
      var response =
          await ApiClient().get("/serial-no/companies/$companyId/service-types")
              as List;
      List<serviceTypeModel> ButtonData = response
          .map(
            (data) => serviceTypeModel.fromJson(data as Map<String, dynamic>),
          )
          .toList();
      return ButtonData;
    } catch (e) {
      print("Error fetching or parsing GetAddButtonServiceType - : $e");
      return [];
    }
  }

  //delete api
  // Future<void> deleteServiceType(String companyId, String Id) async {
  //   try {
  //     await ApiClient().delete(
  //       "/serial-no/companies/$companyId/service-types/$Id",
  //     );
  //   } catch (e) {
  //     print(" Error in ServiceType deleteUser API: $e");
  //     rethrow;
  //   }
  // }

  Future<bool> deleteServiceType({
    required String companyId,
    required String serviceTypeId,
  }) async {
    final String endpoint =
        "/serial-no/companies/$companyId/service-types/$serviceTypeId";

    return await _apiClient.delete(endpoint);
  }
}
