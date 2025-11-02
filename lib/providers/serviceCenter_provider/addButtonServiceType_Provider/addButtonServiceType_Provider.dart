import 'package:flutter/cupertino.dart';
import 'package:SerialMan/api/serviceCenter_api/addButton_ServiceCenter_api/addButton_api.dart';
import 'package:SerialMan/api/serviceCenter_api/addButton_serviceType/addbutton_serviceType.dart';
import 'package:SerialMan/request_model/serviceCanter_request/addButton_request/add_Button_request.dart';
import 'package:SerialMan/request_model/serviceCanter_request/addButton_serviceType_request/addButtonServiceType_request.dart';

class AddButtonServiceTypeProvider with ChangeNotifier {
  final AddButtonServiceType _addButtonServiceType = AddButtonServiceType();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> addButtonServiceType(
    AddButtonServiceTypeRequest request,
    String companyId,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _addButtonServiceType.addButton_serviceType(request, companyId);
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
