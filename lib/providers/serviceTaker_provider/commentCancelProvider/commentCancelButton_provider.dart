import 'package:flutter/cupertino.dart';
import 'package:SerialMan/request_model/seviceTaker_request/commentCancel_request/commentCancel_request.dart';
import '../../../api/serviceTaker_api/commentCencel_serviceTaker/commentCencel_serviceTaker.dart';

class CommentCancelButtonProvider with ChangeNotifier {
  final CommentCancelService _commentCancelService = CommentCancelService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> commentCancelButton(
    CommentCancelRequest commentCancelRequest,
    String id,
    String serviceCenterId,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _commentCancelService.UpdateCommentCancelButton(
        commentCancelRequest,
        id,
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
