import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:SerialMan/api/serviceCenter_api/newSerialButton_servicecenter/newSerialButton.dart';
import 'package:SerialMan/model/serialService_model.dart';

class GetNewSerialButtonProvider with ChangeNotifier {
  final NewSerialButtonService _newSerialButtonService =
      NewSerialButtonService();

  List<SerialModel> _allSerials = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<SerialModel> get queueSerials {
    final items = _allSerials
        .where((s) => s.status?.toLowerCase() != 'served')
        .toList();
    items.sort((a, b) => (a.serialNo ?? 0).compareTo(b.serialNo ?? 0));
    return items;
  }

  List<SerialModel> get servedSerials =>
      _allSerials.where((s) => s.status?.toLowerCase() == 'served').toList()
        ..sort((a, b) => (a.serialNo ?? 0).compareTo(b.serialNo ?? 0));

  SerialModel? get nextInQueue {
    final servingSerial = currentlyServingSerial;
    if (servingSerial != null) {
      return servingSerial;
    }

    const activeQueueStatuses = {'booked', 'present', 'waiting'};
    return _allSerials
        .where((s) => activeQueueStatuses.contains(s.status?.toLowerCase()))
        .sortedBy<num>((s) => s.serialNo ?? 0)
        .firstOrNull;
  }

  int get totalQueueCount {
    return queueSerials.length;
  }

  int get totalServedCount {
    return servedSerials.length;
  }

  double get totalServedAmount {
    if (servedSerials.isEmpty) {
      return 0.0;
    }
    return servedSerials.fold(0.0, (sum, item) {
      return sum + (item.charge ?? 0.0);
    });
  }

  SerialModel? get currentlyServingSerial {
    try {
      return _allSerials.firstWhere(
        (serial) => serial.status?.toLowerCase() == "serving",
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> fetchSerialsButton(String serviceCenterId, String date) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allSerials = await _newSerialButtonService.getNewSerialButton(
        serviceCenterId,
        date,
      );
    } catch (e) {
      _errorMessage = e.toString();
      _allSerials = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearData() {
    //_serials = [];
    _isLoading = false;
    _errorMessage = null;

    notifyListeners();
    print("SerialListProvider cleared!");
  }
}
