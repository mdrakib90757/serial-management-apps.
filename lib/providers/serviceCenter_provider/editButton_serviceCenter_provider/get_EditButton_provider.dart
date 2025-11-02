import 'package:flutter/material.dart';
import '../../../api/serviceCenter_api/updateButton_serviceCanter/editButton_serviceCenter.dart';
import '../../../model/serviceCenter_model.dart';

class GetEditButtonProvider with ChangeNotifier {
  final EditButtonApi _editButtonApi = EditButtonApi();

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

  Future<void> fetchGetEditButton(String companyId) async {
    _isLoading = true;
    notifyListeners();

    if (companyId.isEmpty) {
      print("Company ID is missing. Can't fetch service centers.");
      _isLoading = false;
      notifyListeners();
      return;
    }

    debugPrint("Fetching service centers for company: $companyId");
    _serviceCenterList = await _editButtonApi.GetEditButtonService(companyId);

    _isLoading = false;
    notifyListeners();
  }

  void clearData() {
    _serviceCenterList = [];
    _token = null;
    _isLoading = false;

    notifyListeners();
    print("GetEditButtonProvider cleared!");
  }
}
