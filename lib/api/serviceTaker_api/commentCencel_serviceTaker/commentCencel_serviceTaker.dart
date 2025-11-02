import 'dart:convert';

import 'package:SerialMan/core/api_client.dart';
import 'package:SerialMan/model/mybooked_model.dart';
import 'package:SerialMan/request_model/seviceTaker_request/commentCancel_request/commentCancel_request.dart';

class CommentCancelService {
  Future<dynamic> UpdateCommentCancelButton(
    CommentCancelRequest commentCancelRequest,
    String id,
    String serviceCenterId,
  ) async {
    String body = jsonEncode(commentCancelRequest.toJson());
    final response = ApiClient().put(
      "/serial-no/service-centers/$serviceCenterId/services/$id",
      body: body,
    );
    return response;
  }

  Future<List<MybookedModel>> getCommentCancelButton(String date) async {
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
