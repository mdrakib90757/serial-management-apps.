class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String getMessage() {
    return _message;
  }

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
    : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class NotFoundException extends AppException {
  NotFoundException([message]) : super(message, "Not Found: ");
}

class ForbiddenException extends AppException {
  ForbiddenException([message]) : super(message, "Forbidden: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}

class RequestConflictException extends AppException {
  RequestConflictException([message]) : super(message, "Conflicted Request: ");
}

class UnknownException extends AppException {
  UnknownException([message]) : super(message, "Unknown Exception: ");
}

class NoContentException extends AppException {
  NoContentException([message]) : super(message, "No Content: ");
}
