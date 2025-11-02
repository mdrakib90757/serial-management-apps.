import 'package:flutter/cupertino.dart';
import 'package:SerialMan/api/serviceCenter_api/addButton_ServiceCenter_api/addButton_api.dart';
import 'package:SerialMan/request_model/serviceCanter_request/addButton_request/add_Button_request.dart';

class AddButtonProvider with ChangeNotifier {
  final AddButtonApi _addButtonApi = AddButtonApi();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> addButton(AddButtonRequest request, String companyId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _addButtonApi.addButton_service(request, companyId);
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
