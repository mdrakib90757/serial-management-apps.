import 'dart:convert';

import '../../../core/api_client.dart';
import '../../../model/mybooked_model.dart';
import '../../../request_model/seviceTaker_request/update_bookSerialRequest/update_bookSerialRequest.dart';

class UpdateBookSerialService {
  Future<dynamic> Update_bookSerial(
    UpdateBookSerialRequest request,
    String id,
    String serviceCenterId,
  ) async {
    String body = jsonEncode(request.toJson());
    final response = ApiClient().put(
      "/serial-no/service-centers/$serviceCenterId/services/$id",
      body: body,
    );
    return response;
  }

  Future<List<MybookedModel>> get_UpdateBookSerial(String date) async {
    try {
      final Map<String, String> queryParameters = {'date': date};
      var response =
          await ApiClient().get(
                "/my-booked-services",
                queryParameters: queryParameters,
              )
              as List;
      List<MybookedModel> ButtonData = response
          .map((data) => MybookedModel.fromJson(data as Map<String, dynamic>))
          .toList();
      return ButtonData;
    } catch (e) {
      print("Error fetching or parsing GetCommentCancelButton - : $e");
      return [];
    }
  }
}
