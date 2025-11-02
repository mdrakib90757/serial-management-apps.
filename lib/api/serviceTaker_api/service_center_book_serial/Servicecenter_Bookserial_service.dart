import '../../../core/api_client.dart';
import '../../../model/serviceCenter_model.dart';

class Servicecenter_Bookserial_service {
  Future<List<ServiceCenterModel>> ServicecenterBookserialService(
    String companyId,
  ) async {
    try {
      var response =
          await ApiClient().get(
                "/serial-no/companies/$companyId/service-centers",
              )
              as List;
      List<ServiceCenterModel> ButtonData = response
          .map(
            (data) => ServiceCenterModel.fromJson(data as Map<String, dynamic>),
          )
          .toList();
      return ButtonData;
    } catch (e) {
      print(
        "Error fetching or parsing Servicecenter_Bookserial_service - : $e",
      );
      return [];
    }
  }
}
