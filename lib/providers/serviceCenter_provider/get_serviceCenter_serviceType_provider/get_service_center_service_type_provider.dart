import 'package:flutter/material.dart';
import '../../../../api/serviceCenter_api/service_center_service_type_service/service_center_service_type_service.dart';
import '../../../../model/service_type_model.dart';

class get_service_center_service_type_provider with ChangeNotifier {
  final service_center_service_type_service _secondServiceTypeService =
      service_center_service_type_service();

  List<serviceTypeModel> _serviceTypesOfSelectedCenter = [];
  List<serviceTypeModel> get serviceTypesOfSelectedCenter =>
      _serviceTypesOfSelectedCenter;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetch_service_center_service_type(String serviceCenterId) async {
    _isLoading = true;
    notifyListeners();

    if (serviceCenterId.isEmpty) {
      print("Service Center ID is missing. Cannot fetch service types.");
      _serviceTypesOfSelectedCenter = [];
      _isLoading = false;
      notifyListeners();
      return;
    }
    debugPrint("Fetching service types for service center: $serviceCenterId");

    _serviceTypesOfSelectedCenter = await _secondServiceTypeService
        .fetch_serviceCenter_serviceType(serviceCenterId);
    _isLoading = false;
    notifyListeners();
  }

  void addServiceTypeLocally(serviceTypeModel newServiceType) {
    _serviceTypesOfSelectedCenter.add(newServiceType);
    notifyListeners();
  }

  void clearData() {
    _serviceTypesOfSelectedCenter = [];
    _isLoading = false;

    notifyListeners();
    print("Second ServiceType cleared!");
  }
}
