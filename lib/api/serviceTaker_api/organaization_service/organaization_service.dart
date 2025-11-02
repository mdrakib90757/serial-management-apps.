import 'package:SerialMan/core/api_client.dart';
import 'package:SerialMan/model/organization_model.dart';

class organizationService {
  Future<List<OrganizationModel>> fetchOrganization({
    required String businessTypeId,
  }) async {
    try {
      final Map<String, String> queryParameters = {
        'businessTypeId': businessTypeId,
      };

      final response =
          await ApiClient().get(
                "/serial-no/organizations",
                queryParameters: queryParameters,
              )
              as List;
      List<OrganizationModel> organizations = response
          .map(
            (data) => OrganizationModel.fromJson(data as Map<String, dynamic>),
          )
          .toList();

      return organizations;
    } catch (e) {
      print("Error in fetchOrganization: $e");
      return [];
    }
  }
}
