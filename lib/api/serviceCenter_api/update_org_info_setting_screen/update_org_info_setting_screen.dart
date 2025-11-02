import 'dart:convert';

import 'package:SerialMan/model/company_details_model.dart';

import '../../../core/api_client.dart';
import '../../../request_model/serviceCanter_request/update_orginization_request/update_orginization_request.dart';

class UpdateOerganizationService {
  Future<dynamic> updateOrginization(
    UpdateOrginizationRequest organizationRequest,
    String id,
  ) async {
    try {
      String body = jsonEncode(organizationRequest.toJson());
      final response = await ApiClient().put("/companies/$id", body: body);
      return response;
    } catch (e) {
      print(e);
    }
  }

  Future<CompanyDetailsModel> getUpdateOrginization(String id) async {
    try {
      final response = await ApiClient().get("/companies/$id");
      return CompanyDetailsModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
