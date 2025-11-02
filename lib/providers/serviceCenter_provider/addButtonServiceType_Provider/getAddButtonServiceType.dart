import 'package:flutter/material.dart';
import 'package:SerialMan/api/serviceCenter_api/addButton_serviceType/addbutton_serviceType.dart';

import '../../../model/service_type_model.dart';

class GetAddButtonServiceType_Provider with ChangeNotifier {
  final AddButtonServiceType _addButtonServiceType = AddButtonServiceType();

  String? _token;
  String? get token => _token;

  List<serviceTypeModel> _serviceTypeList = [];
  List<serviceTypeModel> get serviceTypeList => _serviceTypeList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchGetAddButton_ServiceType(String companyId) async {
    _isLoading = true;
    notifyListeners();

    if (companyId.isEmpty) {
      print("Company ID is missing. Cannot fetch service types.");
      _serviceTypeList = [];
      _isLoading = false;
      notifyListeners();
      return;
    }
    debugPrint("Fetching service centers with a valid token...");

    _serviceTypeList = await _addButtonServiceType.getAddButtonServiceType(
      companyId,
    );

    _isLoading = false;
    notifyListeners();
  }

  void clearData() {
    _serviceTypeList = [];
    _token = null;
    _isLoading = false;

    notifyListeners();
    print("GetAddButtonServiceTypeProvider cleared!");
  }
}
