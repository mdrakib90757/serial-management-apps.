import 'package:flutter/material.dart';
import '../../../model/serviceCenter_model.dart';
import '../../api/serviceTaker_api/serviceTaker_businessType/serviceTaker_businessType.dart';

class ServiceCenterByTypeProvider with ChangeNotifier {
  final ServiceTakerBusinessTypeApi _api = ServiceTakerBusinessTypeApi();

  List<ServiceCenterModel> _serviceCenters = [];
  List<ServiceCenterModel> get serviceCenters => _serviceCenters;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Fetch service centers from API using ServiceTakerApi
  Future<bool> fetchServiceCenters(String businessTypeId) async {
    _isLoading = true;
    _errorMessage = null;
    _serviceCenters = [];
    notifyListeners();

    try {
      final data = await _api.fetchBusinessType(businessTypeId);

      _serviceCenters = data;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _serviceCenters = [];
      _errorMessage = e.toString().replaceAll("Exception: ", "").trim();
      _isLoading = false;
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear provider state
  void clearData() {
    _serviceCenters = [];
    notifyListeners();
  }
}
