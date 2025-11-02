import 'package:flutter/material.dart';
import 'package:SerialMan/api/serviceCenter_api/addButton_ServiceCenter_api/addButton_api.dart';
import '../../../model/serviceCenter_model.dart';

class GetAddButtonProvider with ChangeNotifier {
  final AddButtonApi _addButtonApi = AddButtonApi();

  String? _token;
  String? get token => _token;

  List<ServiceCenterModel> _serviceCenterList = [];
  List<ServiceCenterModel> get serviceCenterList => _serviceCenterList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? selectedServiceCenterId;

  void selectCenter(String id) {
    selectedServiceCenterId = id;
    notifyListeners();
  }

  Future<void> fetchGetAddButton(String companyId) async {
    _isLoading = true;
    notifyListeners();

    if (companyId.isEmpty) {
      print(" Company ID is missing. Can't fetch service centers.");
      _isLoading = false;
      notifyListeners();
      return;
    }

    debugPrint("Fetching service centers for company: $companyId");
    _serviceCenterList = await _addButtonApi.GetAddButton(companyId);

    _isLoading = false;
    notifyListeners();
  }

  void clearData() {
    _serviceCenterList = [];
    _token = null;
    _isLoading = false;

    notifyListeners();
    print("GetAddButtonProvider cleared!");
  }
}
