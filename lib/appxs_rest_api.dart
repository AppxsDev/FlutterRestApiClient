// ignore_for_file: constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

import 'appxs_rest_api_config.dart';
import 'appxs_rest_api_exception.dart';
import 'appxs_rest_api_logger.dart';
import 'appxs_rest_api_utils.dart';

enum Method { GET, POST, PUT, PATCH, DELETE }

class AppxsRestApi {
  final String endpoint;
  final Method method;
  final Map<String, dynamic>? requestJSON;
  final bool isTest;

  var response;

  AppxsRestApi(
      {required this.endpoint,
      required this.method,
      this.requestJSON,
      this.isTest = false});

  Future<void> executeRequest() async {
    if (AppxsRestApiUtils.isAPIInitializated()) {
      await AppxsRestApiUtils.hasConnection()
          .timeout(AppxsRestApiConfig.getRequestTimeout())
          .then((hasConnection) async {
        if (hasConnection) {
          Uri requestURL =
              AppxsRestApiUtils.mountURL(isTest: isTest, endpoint: endpoint);
          AppxsRestApiLogger.openBox();
          AppxsRestApiLogger.log(
              Level.debug, "[API] - Calling: " + requestURL.toString());
          try {
            Stopwatch stopwatch = Stopwatch()..start();
            switch (method) {
              case Method.GET:
                response = await get(requestURL);
                break;
              case Method.POST:
                response = await post(requestURL, body: requestJSON);
                break;
              case Method.PUT:
                response = await put(requestURL, body: requestJSON);
                break;
              case Method.PATCH:
                response = await patch(requestURL, body: requestJSON);
                break;
              case Method.DELETE:
                response = await delete(requestURL, body: requestJSON);
                break;
            }
            stopwatch.stop();
            AppxsRestApiLogger.log(
                Level.debug,
                "[API] - " +
                    getStatus().toString() +
                    " | Time Elapsed: " +
                    stopwatch.elapsed.inMilliseconds.toString() +
                    "MS");
            AppxsRestApiLogger.closeBox();
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
    if (response != null) {
      return response.statusCode;
    } else {
      return 500;
    }
  }

  AppxsRestApiException getException() {
    if (response != null) {
      Map responseJSON = getResponse();
      if (AppxsRestApiConfig.getResponseKey() != null) {
        if (responseJSON.containsKey(AppxsRestApiConfig.getResponseKey())) {
          return AppxsRestApiException(
              code:
                  int.parse(responseJSON[AppxsRestApiConfig.getResponseKey()]));
        }
      }
    }

    return AppxsRestApiException.buildUnexpectedError();
  }

  Map<String, dynamic> getResponse() {
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
