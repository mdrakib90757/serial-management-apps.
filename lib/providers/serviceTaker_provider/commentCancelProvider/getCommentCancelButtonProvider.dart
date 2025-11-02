import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:SerialMan/model/mybooked_model.dart';
import '../../../api/serviceTaker_api/commentCencel_serviceTaker/commentCencel_serviceTaker.dart';

class GetCommentCancelButtonProvider with ChangeNotifier {
  final CommentCancelService _commentCancelService = CommentCancelService();

  List<MybookedModel> _bookSerialList = [];
  List<MybookedModel> get bookSerialList => _bookSerialList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> get_commentCancelButton(String date) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _bookSerialList = await _commentCancelService.getCommentCancelButton(
        date,
      );
    } catch (e) {
      _errorMessage = e.toString();
      _bookSerialList = [];
    }
    _isLoading = false;
    notifyListeners();
  }
}
