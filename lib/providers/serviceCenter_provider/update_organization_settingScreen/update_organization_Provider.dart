import 'package:flutter/cupertino.dart';
import 'package:SerialMan/request_model/serviceCanter_request/update_orginization_request/update_orginization_request.dart';

import '../../../api/serviceCenter_api/update_org_info_setting_screen/update_org_info_setting_screen.dart';

class UpdateOrganizationInfoProvider with ChangeNotifier {
  final UpdateOerganizationService _updateOerganizationService =
      UpdateOerganizationService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> updateOrignazation(
    UpdateOrginizationRequest request,
    String id,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _updateOerganizationService.updateOrginization(request, id);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "").trim();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
