import 'package:SerialMan/model/ServiceTypesDeFaultifNotSet.dart';
import 'package:flutter/material.dart';

import '../../../api/serviceCenter_api/newSerialButton_servicecenter/service-types_defaultIf_not_set/service-types_defaultIf_not_set.dart';

enum NotifierState { initial, loading, loaded, error }

class service_types_de_faultif_not_setProvider with ChangeNotifier {
  final ServiceTypesDeFaultifNotSetApi _apiService =
      ServiceTypesDeFaultifNotSetApi();

  NotifierState _state = NotifierState.initial;
  NotifierState get state => _state;

  List<ServiceTypesDeFaultifNotSetModel> _serviceTypes = [];
  List<ServiceTypesDeFaultifNotSetModel> get serviceTypes => _serviceTypes;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> fetchServiceTypes(String serviceCenterId) async {
    _state = NotifierState.loading;
    notifyListeners();

    try {
      _serviceTypes = await _apiService.serviceTypesDeFaultifNotSet(
        serviceCenterId,
      );
      _state = NotifierState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = NotifierState.error;
    }

    notifyListeners();
  }
}
