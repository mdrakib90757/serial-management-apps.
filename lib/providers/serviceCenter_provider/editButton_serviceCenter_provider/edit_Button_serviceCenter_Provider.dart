import 'package:flutter/cupertino.dart';

import '../../../api/serviceCenter_api/updateButton_serviceCanter/editButton_serviceCenter.dart';
import '../../../request_model/serviceCanter_request/editButton_request_serviceCenter/edit_Button_request.dart';

class EditButtonProvider with ChangeNotifier {
  final EditButtonApi _editButtonApi = EditButtonApi();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> editButton(
    EditButtonRequest request,
    String companyId,
    String id,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _editButtonApi.EditButtonService(request, companyId, id);
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
