import '../../../core/api_client.dart';
import '../../../model/serviceCenter_model.dart';

class ServiceTakerBusinessTypeApi {
  //BusinessType
  Future<List<ServiceCenterModel>> fetchBusinessType(
    String businessTypeId,
  ) async {
    try {
      var response =
          await ApiClient().get(
                "/serial-no/service-centers",
                queryParameters: {'businessTypeId': businessTypeId.toString()},
              )
              as List;
      List<ServiceCenterModel> types = response
          .map(
            (item) => ServiceCenterModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();

      return types;
    } catch (e) {
      print("Error fetching or parsing business types: $e");
      return [];
    }
  }
}
