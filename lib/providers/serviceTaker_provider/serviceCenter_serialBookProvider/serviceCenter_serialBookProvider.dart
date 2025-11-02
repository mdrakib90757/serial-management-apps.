import 'package:flutter/material.dart';
import '../../../api/serviceTaker_api/service_center_book_serial/Servicecenter_Bookserial_service.dart';
import '../../../model/serviceCenter_model.dart';

class serviceCenter_serialBookProvider with ChangeNotifier {
  final Servicecenter_Bookserial_service _servicecenter_bookserial_service =
      Servicecenter_Bookserial_service();

  List<ServiceCenterModel> _serviceCenterList = [];
  List<ServiceCenterModel> get serviceCenterList => _serviceCenterList;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? selectedServiceCenterId;
  void selectCenter(String id) {
    selectedServiceCenterId = id;
    notifyListeners();
  }

  Future<bool> fetchserviceCnter_serialbook(String companyId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _serviceCenterList =
          await _servicecenter_bookserial_service.ServicecenterBookserialService(
            companyId,
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

  void clearData() {
    _serviceCenterList = [];
    _isLoading = false;
    notifyListeners();
    print("serviceCenter_serialBookProvider cleared!");
  }
}
