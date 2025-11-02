import 'package:flutter/cupertino.dart';

import '../../../../api/serviceCenter_api/update_org_info_setting_screen/update_org_info_setting_screen.dart';
import '../../../../model/company_details_model.dart';

class getUpdateOrganization with ChangeNotifier {
  final UpdateOerganizationService _updateOrganizationService =
      UpdateOerganizationService();

  CompanyDetailsModel? _companyDetails;
  bool _isLoading = false;
  String? _errorMessage;
  CompanyDetailsModel? get companyDetails => _companyDetails;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchDetails(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _companyDetails = await _updateOrganizationService.getUpdateOrginization(
        id,
      );
      debugPrint(
        " update organization info loaded for: ${_companyDetails?.name}",
      );
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint(" Failed to load update organization info : $_errorMessage");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
