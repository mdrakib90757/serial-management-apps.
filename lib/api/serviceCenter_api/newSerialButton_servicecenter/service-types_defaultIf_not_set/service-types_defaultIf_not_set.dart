import 'package:SerialMan/core/api_client.dart';
import 'package:SerialMan/model/ServiceTypesDeFaultifNotSet.dart';

class ServiceTypesDeFaultifNotSetApi {
  Future<List<ServiceTypesDeFaultifNotSetModel>> serviceTypesDeFaultifNotSet(
    String serviceCenterId,
  ) async {
    try {
      final Map<String, String> queryParameters = {'defaultIfNotSet': 'true'};
      var response = await ApiClient().get(
        "/serial-no/service-centers/$serviceCenterId/service-types",
        queryParameters: queryParameters,
      );

      List<ServiceTypesDeFaultifNotSetModel> serviceTypesList =
          (response as List<dynamic>)
              .map(
                (data) => ServiceTypesDeFaultifNotSetModel.fromJson(
                  data as Map<String, dynamic>,
                ),
              )
              .toList();

      return serviceTypesList;
    } catch (e) {
      print("Error fetching or parsing ServiceTypesDeFaultifNot - : $e");
      return [];
    }
  }
}
