import 'dart:convert';

import 'package:SerialMan/model/myService_model.dart';
import '../../../core/api_client.dart';

class MySerialService {
  Future<List<MyService>> fetchMyServices({
    required int pageNo,
    required int pageSize,
  }) async {
    try {
      final response =
          await ApiClient().get(
                "/serial-no/my-services",
                queryParameters: {
                  'pageNo': pageNo.toString(),
                  'pageSize': pageSize.toString(),
                },
              )
              as List;

      List<MyService> services = response
          .map((item) => MyService.fromJson(item as Map<String, dynamic>))
          .toList();

      return services;
    } catch (e) {
      print("Error in fetchMyServices: $e");
      return [];
    }
  }
}
