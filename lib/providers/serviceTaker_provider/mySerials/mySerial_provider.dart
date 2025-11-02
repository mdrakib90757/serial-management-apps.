import 'package:flutter/material.dart';
import '../../../api/serviceTaker_api/myserials_serviceTaker/my_serials_service.dart';
import '../../../model/myService_model.dart';

class MySerialServiceTakerProvider with ChangeNotifier {
  final MySerialService _mySerialService = MySerialService();

  List<MyService> _allServices = [];
  List<MyService> get myServices => _allServices;

  int _currentPage = 1;
  final int _pageSize = 10;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isFirstLoad = true;

  Future<void> fetchMyServices({bool isRefresh = false}) async {
    if (_isLoading || (!_hasMore && !isRefresh)) return;

    _isLoading = true;
    if (_isFirstLoad || isRefresh) {
      notifyListeners();
    }

    if (isRefresh) {
      _currentPage = 1;
      _allServices = [];
      _hasMore = true;
      _isFirstLoad = true;
    }

    try {
      final newServices = await _mySerialService.fetchMyServices(
        pageNo: _currentPage,
        pageSize: _pageSize,
      );

      if (newServices.length < _pageSize) {
        _hasMore = false;
      }

      _allServices.addAll(newServices);
      _currentPage++;
    } catch (e) {
      debugPrint("Error fetching my services: $e");
    } finally {
      _isLoading = false;
      _isFirstLoad = false;
      notifyListeners();
    }
  }
}
