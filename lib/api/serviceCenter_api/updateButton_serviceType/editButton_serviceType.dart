import 'dart:convert';

import 'package:SerialMan/model/service_type_model.dart';
import 'package:SerialMan/request_model/serviceCanter_request/editButtonServiceType_request/editButtonServiceType_reqeust.dart';

import '../../../core/api_client.dart';

class EditButtonServiceTypeApi {
  Future<dynamic> EditButtonServiceType(
    EditButtonServiceTypeRequest edit_request,
    String companyId,
    String id,
  ) async {
    String body = jsonEncode(edit_request.toJson());
    final response = ApiClient().put(
      "/serial-no/companies/$companyId/service-types/$id",
      body: body,
    );
    return response;
  }

  Future<List<serviceTypeModel>> GetEditButtonServiceType(
    String companyId,
  ) async {
    try {
      var response =
          await ApiClient().get(
                "/serial-no/companies/$companyId/service-centers",
              )
              as List;
      List<serviceTypeModel> ButtonData = response
          .map(
            (data) => serviceTypeModel.fromJson(data as Map<String, dynamic>),
          )
          .toList();
      return ButtonData;
    } catch (e) {
      print("Error fetching or parsing GetEditButton - : $e");
      return [];
    }
  }
}
