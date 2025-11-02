import 'package:flutter/cupertino.dart';
import 'package:SerialMan/api/serviceCenter_api/updateButton_serviceType/editButton_serviceType.dart';
import 'package:SerialMan/request_model/serviceCanter_request/editButtonServiceType_request/editButtonServiceType_reqeust.dart';

class EditButtonServiceTypeProvider with ChangeNotifier {
  final EditButtonServiceTypeApi _editButtonServiceTypeApi =
      EditButtonServiceTypeApi();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> editButtonServiceType(
    EditButtonServiceTypeRequest request,
    String companyId,
    String id,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _editButtonServiceTypeApi.EditButtonServiceType(
        request,
        companyId,
        id,
      );
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
