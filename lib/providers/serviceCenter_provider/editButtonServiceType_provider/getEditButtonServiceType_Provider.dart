import 'package:flutter/material.dart';
import 'package:SerialMan/api/serviceCenter_api/updateButton_serviceType/editButton_serviceType.dart';
import 'package:SerialMan/model/service_type_model.dart';
import '../../../api/serviceCenter_api/updateButton_serviceCanter/editButton_serviceCenter.dart';
import '../../../model/serviceCenter_model.dart';

class GetEditButtonServiceTypeProvider with ChangeNotifier {
  final EditButtonServiceTypeApi _editButtonServiceTypeApi =
      EditButtonServiceTypeApi();

  String? _token;
  String? get token => _token;

  List<serviceTypeModel> _serviceTypeList = [];
  List<serviceTypeModel> get serviceTypeList => _serviceTypeList;

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
      print(" Company ID is missing. Can't fetch service centers.");
      _isLoading = false;
      notifyListeners();
      return;
    }

    debugPrint(" Fetching service centers for company: $companyId");
    _serviceTypeList = await _editButtonServiceTypeApi.GetEditButtonServiceType(
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
    print("GetEditButtonProvider cleared!");
  }
}
