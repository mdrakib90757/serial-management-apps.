import 'dart:convert';

import 'package:SerialMan/request_model/serviceCanter_request/add_service_center_service_type_request/service_center_service_type_request.dart';

import '../../../core/api_client.dart';
import '../../../model/service_type_model.dart';
import '../../../request_model/serviceCanter_request/update_service_center_service_type_request/update_service_center_service_type_request.dart';

class service_center_service_type_service {
  //add button service center and service type
  Future<dynamic> add_service_center_service_type(
    String serviceCenterId,
    add_service_center_service_type_request requestData,
  ) async {
    String body = jsonEncode(requestData.toJson());
    final response = await ApiClient().post(
      "/serial-no/service-centers/$serviceCenterId/service-types",
      body: body,
    );
    return response;
  }

  //Get AddButton service center and service type
  Future<List<serviceTypeModel>> fetch_serviceCenter_serviceType(
    String serviceCenterId,
  ) async {
    try {
      var response =
          await ApiClient().get(
                "/serial-no/service-centers/$serviceCenterId/service-types",
              )
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

  //update service center and service type
  Future<dynamic> update_service_center_service_type_service(
    update_service_center_service_type_request request,
    String serviceCenterId,
  ) async {
    try {
      String body = jsonEncode(request.toJson());
      final response = await ApiClient().put(
        "/serial-no/service-centers/$serviceCenterId/service-types",
        body: body,
      );
      return response;
    } catch (e) {
      print(
        "Error fetching or parsing update_service_center_service_type_service - : $e",
      );
      throw Exception(e.toString());
    }
  }

  //delete service center and service type
  Future<void> deleteServiceCenter_serviceType(
    String serviceCenterId,
    String serviceTypeId,
  ) async {
    try {
      await ApiClient().delete(
        "/serial-no/service-centers/$serviceCenterId/service-types/$serviceTypeId",
      );
    } catch (e) {
      print("Error in ServiceCenter deleteUser API: $e");
      throw Exception(e);
    }
  }
}
