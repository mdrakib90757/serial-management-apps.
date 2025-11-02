import 'package:flutter/cupertino.dart';

import '../../../../api/serviceCenter_api/newSerialButton_servicecenter/queue_list_edit_service/queue_list_edit_service.dart';
import '../../../../request_model/serviceCanter_request/newSerialButton_request/queue_edit_list_request/queue_edit_list_request.dart';

class QueueListEditProvider with ChangeNotifier {
  final QueueListEditService _service = QueueListEditService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> QueueListEdit(
    queueEditListRequest queueListEditRequest,
    String serviceCenterId,
    String id,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _service.QueueListEdit(queueListEditRequest, serviceCenterId, id);
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
