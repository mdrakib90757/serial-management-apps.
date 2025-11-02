import 'package:flutter/material.dart';
import 'package:SerialMan/api/serviceCenter_api/addButton_ServiceCenter_api/addButton_api.dart';
import 'package:SerialMan/api/serviceCenter_api/addUser_serviceCenter/addUser_serviceCenter.dart';

import '../../../../core/app_exception.dart';

class DeleteServiceCenterProvider with ChangeNotifier {
  final AddButtonApi _api = AddButtonApi();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
  }

  Future<bool> deleteServiceCenter({
    required String companyId,
    required String serviceCenterId,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final bool success = await _api.deleteServiceCenter(
        companyId: companyId,
        serviceCenterId: serviceCenterId,
      );

      _setLoading(false);
      return success;
    } on AppException catch (e) {
      _setError(e.getMessage());
      _setLoading(false);
      return false;
    } catch (e) {
      _setError("An unexpected error occurred: ${e.toString()}");
      _setLoading(false);
      return false;
    }
  }
}
