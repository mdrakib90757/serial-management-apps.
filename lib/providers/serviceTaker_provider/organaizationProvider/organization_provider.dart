import 'package:flutter/cupertino.dart';
import '../../../api/serviceTaker_api/organaization_service/organaization_service.dart';
import '../../../model/organization_model.dart';

class OrganizationProvider with ChangeNotifier {
  final organizationService _organizationService = organizationService();

  List<OrganizationModel> _organizations = [];
  List<OrganizationModel> get organizations => _organizations;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> get_Organization({required String businessTypeId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _organizations = await _organizationService.fetchOrganization(
        businessTypeId: businessTypeId,
      );
    } catch (e) {
      _errorMessage = e.toString();
      _organizations = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearData() {
    _organizations = [];
    notifyListeners();
  }
}
