import 'package:SerialMan/core/app_exception.dart';
import 'package:flutter/material.dart';
import '../../../../api/serviceCenter_api/addButton_serviceType/addbutton_serviceType.dart';

class DeleteServiceTypeProvider with ChangeNotifier {
  final AddButtonServiceType _api = AddButtonServiceType();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
  }

  Future<bool> delete_serviceType({
    required String companyId,
    required String Id,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final bool success = await _api.deleteServiceType(
        companyId: companyId,
        serviceTypeId: Id,
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
