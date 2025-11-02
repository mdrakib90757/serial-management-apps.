import '../../../core/api_client.dart';
import '../../../model/serviceCenter_model.dart';
import '../../../model/service_type_model.dart';

class serviceTypeSerialBook_service {
  Future<List<serviceTypeModel>> serviceTypeSerialBook(String companyId) async {
    try {
      var response =
          await ApiClient().get("/serial-no/companies/$companyId/service-types")
              as List;
      List<serviceTypeModel> ButtonData = response
          .map(
            (data) => serviceTypeModel.fromJson(data as Map<String, dynamic>),
          )
          .toList();
      return ButtonData;
    } catch (e) {
      print("Error fetching or parsing serviceTypeSerialBook_service - : $e");
      return [];
    }
  }
}
