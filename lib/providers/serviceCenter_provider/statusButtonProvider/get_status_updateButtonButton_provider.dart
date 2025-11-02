import 'package:flutter/material.dart';
import 'package:SerialMan/api/serviceCenter_api/statusButton_serviceCenter/status_updateButton_service.dart';
import 'package:SerialMan/model/serialService_model.dart';

class getStatusUpdate_Provider with ChangeNotifier {
  final StatusUpdateButtonService _statusUpdateButton =
      StatusUpdateButtonService();
  List<SerialModel> _serials = [];
  List<SerialModel> get serials => _serials;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchStatusButton(String serviceCenterId, String? date) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _serials = await _statusUpdateButton.GetStatusButtonService(
        serviceCenterId,
        date,
      );
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "").trim();
      _serials = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  void clearData() {
    _serials = [];
    _isLoading = false;
    _errorMessage = null;

    notifyListeners();
    print("SerialListProvider cleared!");
  }
}
