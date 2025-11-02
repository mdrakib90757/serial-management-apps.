import 'dart:async';
import 'dart:convert' as convert;
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:http_parser/http_parser.dart';
import 'package:SerialMan/core/app_exception.dart';
import 'package:SerialMan/core/exception_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final Duration timeout = Duration(seconds: 55);
  final String _baseUrl = 'serialno-api.somee.com';

  static Future<Map<String, String>> _getHeaders() async {
    Map<String, String> headers = {};
    headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    return headers;
  }

  static RetryClient _getClient() {
    return RetryClient(
      http.Client(),
      retries: 3,
      when: (response) {
        return response.statusCode == 401;
      },
      onRetry: (req, res, retryCount) async {
        if (retryCount == 0 && res?.statusCode == 401) {
          req.headers.clear();
          Map<String, String> headers = await _getHeaders();
          req.headers.addAll(headers);
        }
      },
    );
  }

  dynamic _returnResponse(http.Response response) {
    debugPrint('${response.request!.url.toString()} ${response.statusCode}');
    log(response.body.toString());
    switch (response.statusCode) {
      case 200:
      case 201:
        var responseJson = convert.jsonDecode(response.body.toString());
        return responseJson;
      case 204:
        throw NoContentException();
      case 400:
        var responseJson = convert.jsonDecode(response.body.toString());
        throw BadRequestException(responseJson["errorMessage"]);
      case 401:
        throw UnauthorisedException(response.body.toString());
      case 403:
        throw ForbiddenException(response.body.toString());
      case 404:
        var responseJson = convert.jsonDecode(response.body.toString());
        throw NotFoundException(responseJson["errorMessage"]);
      case 409:
        var responseJson = convert.jsonDecode(response.body.toString());
        throw RequestConflictException(responseJson["errorMessage"]);
      case 422:
        throw InvalidInputException("You have some problem with your input");
      case 500:
      default:
        throw UnknownException(
          'Error Occurred while Communication with Server with StatusCode : ${response.statusCode}',
        );
    }
  }

  Uri createUri(String apiUrl, {Map<String, dynamic>? queryParameters}) =>
      Uri.https(_baseUrl, '/api$apiUrl', queryParameters);

  Future<dynamic> get(
    String apiUrl, {
    Map<String, dynamic>? queryParameters,
  }) async {
    Map<String, String> headers = await _getHeaders();

    try {
      final http.Response response = await _getClient()
          .get(
            createUri(apiUrl, queryParameters: queryParameters),
            headers: headers,
          )
          .timeout(timeout);

      return _returnResponse(response);
    } on Exception catch (exception) {
      ExceptionHandler.handle(exception);
    }
  }

  Future<dynamic> post(
    String apiUrl, {
    String? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    Map<String, String> headers = await _getHeaders();
    try {
      final http.Response response = await _getClient()
          .post(
            createUri(apiUrl, queryParameters: queryParameters),
            headers: headers,
            body: body,
          )
          .timeout(timeout);

      return _returnResponse(response);
    } on Exception catch (exception) {
      ExceptionHandler.handle(exception);
    }
  }

  Future<bool> postMultipart(
    String apiUrl,
    File file, {
    String? filename,
  }) async {
    Map<String, String> headers = await _getHeaders();
    headers['Accept'] = '*/*';
    headers['Content-type'] = 'multipart/form-data';

    try {
      final request = await http.MultipartRequest('POST', createUri(apiUrl));

      var multiPartFile = await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: new MediaType('image', 'png'),
      );
      request.files.add(multiPartFile);
      request.headers.addAll(headers);

      var response = await request.send();
      return response.statusCode == 200;
    } on Exception catch (exception) {
      ExceptionHandler.handle(exception);
    }
    return false;
  }

  Future<bool> postMultipartAttachments(
    String apiUrl,
    List<File> files, {
    String? filename,
  }) async {
    Map<String, String> headers = await _getHeaders();
    headers['Accept'] = '*/*';
    headers['Content-type'] = 'multipart/form-data';

    try {
      final request = await http.MultipartRequest('POST', createUri(apiUrl));

      for (int i = 0; i < files.length; i++) {
        var multiPartFile = await http.MultipartFile.fromPath(
          'files',
          files[i].path,
          contentType: new MediaType('image', 'png'),
        );
        request.files.add(multiPartFile);
      }

      request.headers.addAll(headers);

      var response = await request.send();
      return response.statusCode == 200;
    } on Exception catch (exception) {
      ExceptionHandler.handle(exception);
    }
    return false;
  }

  Future<dynamic> put(String apiUrl, {String? body}) async {
    Map<String, String> headers = await _getHeaders();
    try {
      final http.Response response = await _getClient()
          .put(createUri(apiUrl), body: body, headers: headers)
          .timeout(timeout);

      return _returnResponse(response);
    } on Exception catch (exception) {
      ExceptionHandler.handle(exception);
    }
  }

  Future<dynamic> patch(
    String apiUrl, {
    Map<String, dynamic>? queryParameters,
    String? body,
  }) async {
    Map<String, String> headers = await _getHeaders();
    try {
      final http.Response response = await _getClient()
          .patch(
            createUri(apiUrl, queryParameters: queryParameters),
            headers: headers,
            body: body,
          )
          .timeout(timeout);

      return _returnResponse(response);
    } on Exception catch (exception) {
      ExceptionHandler.handle(exception);
    }
  }

  Future<bool> delete(String apiUrl, {String? body}) async {
    Map<String, String> headers = await _getHeaders();
    try {
      final http.Response response = await _getClient()
          .delete(createUri(apiUrl), body: body, headers: headers)
          .timeout(timeout);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        _returnResponse(response);
        return false;
      }
    } on Exception catch (exception) {
      ExceptionHandler.handle(exception);
      return false;
    }
  }
}
