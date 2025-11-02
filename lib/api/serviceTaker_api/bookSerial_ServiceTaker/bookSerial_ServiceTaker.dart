import 'dart:convert';

import 'package:SerialMan/model/mybooked_model.dart';
import 'package:SerialMan/request_model/seviceTaker_request/bookSerial_request/bookSerial_request.dart';
import '../../../core/api_client.dart';

class BookSerialService {
  Future<dynamic> bookSerialButtonService(
    BookSerialRequest bookSerialRequest,
    String serviceCenterId,
  ) async {
    String body = jsonEncode(bookSerialRequest.toJson());

    final response = await ApiClient().post(
      "/serial-no/service-centers/$serviceCenterId/services/book",
      body: body,
    );
    return response;
  }

  Future<List<MybookedModel>> getBookSerialButtonService(String date) async {
    try {
      final Map<String, String> queryParameters = {'date': date};
      var response =
          await ApiClient().get(
                "/serial-no/my-booked-services",
                queryParameters: queryParameters,
              )
              as List;
      List<MybookedModel> bookSerialList = response
          .map((data) => MybookedModel.fromJson(data as Map<String, dynamic>))
          .toList();
      return bookSerialList;
    } catch (e) {
      print("Error fetching or parsing getbookSerialButtonService - : $e");
      return [];
    }
  }
}
