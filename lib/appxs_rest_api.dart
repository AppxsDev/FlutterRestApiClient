// ignore_for_file: constant_identifier_names, prefer_typing_uninitialized_variables, unused_catch_clause

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

import 'appxs_rest_api_config.dart';
import 'appxs_rest_api_exception.dart';
import 'appxs_rest_api_logger.dart';
import 'appxs_rest_api_utils.dart';

/// Set the method to use at the HTTP request
enum Method { GET, POST, PUT, PATCH, DELETE }

/// Client to use to communicate with an Appxs API. This client is intended
/// to be used as a static object.
class AppxsRestApi {
  final AppxsRestApiConfig config;
  final AppxsRestApiLogger _logger;

  var _response;

  AppxsRestApi({required this.config})
      : _logger = AppxsRestApiLogger.init(config: config);

  Future<void> executeRequest(
      {required String endpoint,
      required Method method,
      required bool isTest,
      Map<String, dynamic>? requestJSON}) async {
    if (config.isInitializated) {
      await AppxsRestApiUtils.hasConnection()
          .timeout(config.requestTimeout)
          .then((hasConnection) async {
        if (hasConnection) {
          Uri requestURL = AppxsRestApiUtils.mountURL(
              isTest: isTest, endpoint: endpoint, config: config);
          _logger.openBox();
          _logger.log(Level.debug, "[API] - Calling: " + requestURL.toString());
          try {
            Stopwatch stopwatch = Stopwatch()..start();
            switch (method) {
              case Method.GET:
                _response = await get(requestURL);
                break;
              case Method.POST:
                _response = await post(requestURL, body: requestJSON);
                break;
              case Method.PUT:
                _response = await put(requestURL, body: requestJSON);
                break;
              case Method.PATCH:
                _response = await patch(requestURL, body: requestJSON);
                break;
              case Method.DELETE:
                _response = await delete(requestURL, body: requestJSON);
                break;
            }
            stopwatch.stop();
            _logger.log(
                Level.debug,
                "[API] - " +
                    getStatus().toString() +
                    " | Time Elapsed: " +
                    stopwatch.elapsed.inMilliseconds.toString() +
                    "MS");
            _logger.closeBox();
          } on FormatException catch (e) {
            throw AppxsRestApiException(code: 5);
          } on TimeoutException catch (e) {
            throw AppxsRestApiException(code: 4);
          } on SocketException catch (e) {
            throw AppxsRestApiException(code: 3);
          }
        } else {
          throw AppxsRestApiException(code: 2);
        }
      });
    } else {
      throw AppxsRestApiException(code: 1);
    }
  }

  int getStatus() {
    if (_response != null) {
      return _response.statusCode;
    } else {
      return 500;
    }
  }

  AppxsRestApiException getException() {
    if (_response != null) {
      Map responseJSON = getResponse();
      if (config.responseKey != null) {
        if (responseJSON.containsKey(config.responseKey)) {
          return AppxsRestApiException(
              code: int.parse(responseJSON[config.responseKey]));
        }
      }
    }

    return AppxsRestApiException.buildUnexpectedError();
  }

  Map<String, dynamic> getResponse() {
    return jsonDecode(_response.body) as Map<String, dynamic>;
  }
}
