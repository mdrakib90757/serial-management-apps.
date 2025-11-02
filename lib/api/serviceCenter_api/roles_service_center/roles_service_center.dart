import 'package:SerialMan/core/api_client.dart';
import 'package:SerialMan/model/roles_model.dart';

class RolesApi {
  Future<List<Data>> RolesInfo() async {
    try {
      var response = await ApiClient().get("/roles") as List;
      List<Data> rolesList = response.map((item) {
        return Data.fromJson(item as Map<String, dynamic>);
      }).toList();

      return rolesList;
    } catch (e) {
      print("Error fetching or parsing RolesInfo  - : $e");
      throw Exception('Failed to load company details');
    }
  }
}
