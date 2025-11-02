import 'dart:async';
import 'dart:io';
import 'package:SerialMan/core/app_exception.dart';

class ExceptionHandler {
  ExceptionHandler();

  static void handle(Exception exception) {
    print(exception);
    if (exception is SocketException) {
      throw FetchDataException('Unable to Connect to the Server');
    } else if (exception is TimeoutException) {
      throw FetchDataException('Connection Timeout!');
    }
    throw exception;
  }
}
