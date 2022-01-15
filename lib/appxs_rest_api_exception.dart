// ignore_for_file: prefer_conditional_assignment, non_constant_identifier_names

class AppxsRestApiException implements Exception {
  final int code;
  late String? description;

  final String _ERROR_UNEXPECTED =
      "An unexpected error has ocurred initializating the API";
  final String _ERROR_API_NOT_INITALIZATED =
      "You must initialize the API calling AppxsRestApiConfig.init() before calling executeRequest()";
  final String _ERROR_NO_CONNECTION = "You don't have internet connection";
  final String _ERROR_UNAVAIABLE_TO_CONNECT =
      "No connection established with the server";
  final String _ERROR_TIMEOUT =
      "The request has exceeded the max time to receive a response";
  final String _ERROR_INVALID_URL = "The endpoint URL is not valid";

  AppxsRestApiException({required this.code, this.description}) {
    if (description == null) {
      description = _getErrorMessage();
    }
  }
  AppxsRestApiException.buildUnexpectedError({this.code = 0}) {
    description = _ERROR_UNEXPECTED;
  }

  String? _getErrorMessage() {
    switch (code) {
      case 0:
        return _ERROR_UNEXPECTED;
      case 1:
        return _ERROR_API_NOT_INITALIZATED;
      case 2:
        return _ERROR_NO_CONNECTION;
      case 3:
        return _ERROR_UNAVAIABLE_TO_CONNECT;
      case 4:
        return _ERROR_TIMEOUT;
      case 5:
        return _ERROR_INVALID_URL;
      default:
        return _ERROR_UNEXPECTED;
    }
  }

  @override
  String toString() {
    return description ?? "";
  }
}
