import 'package:flutter/cupertino.dart';
import '../../../api/serviceTaker_api/update_BookSerialService/update_BookSerialService.dart';
import '../../../request_model/seviceTaker_request/update_bookSerialRequest/update_bookSerialRequest.dart';

class UpdateBookSerialProvider with ChangeNotifier {
  final UpdateBookSerialService _updateBookSerial = UpdateBookSerialService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> update_bookSerial(
    UpdateBookSerialRequest request,
    String id,
    String serviceCenterId,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _updateBookSerial.Update_bookSerial(request, id, serviceCenterId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    }
  }
}
