import 'package:flutter/cupertino.dart';
import 'package:SerialMan/request_model/seviceTaker_request/bookSerial_request/bookSerial_request.dart';
import '../../../api/serviceTaker_api/bookSerial_ServiceTaker/bookSerial_ServiceTaker.dart';

class bookSerialButton_provider with ChangeNotifier {
  final BookSerialService _bookSerialService = BookSerialService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> fetchBookSerialButton(
    BookSerialRequest bookSerial_request,
    serviceCenterId,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _bookSerialService.bookSerialButtonService(
        bookSerial_request,
        serviceCenterId,
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
}
