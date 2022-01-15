import 'appxs_rest_api_exception.dart';
import 'appxs_rest_api_logger.dart';

class AppxsRestApiConfig {
  static late Duration _requestTimeout;
  static late String _productDomain;
  static String? _debugDomain;
  static String? _responseKey;
  static int? _port;

  static bool initializated = false;
  static bool allowLog = false;

  AppxsRestApiConfig.init({
    required String productDomain,
    required Duration requestTimeout,
    bool log = false,
    int? port,
    String? responseKey,
    String? debugDomain,
  }) {
    try {
      initializated = false;

      _setProductionDomain(productDomain);
      _setRequestTimeout(requestTimeout);

      if (port != null) {
        _setPort(port);
      }

      if (debugDomain != null) {
        _setDebugDomain(debugDomain);
      } else {
        _setDebugDomain(productDomain);
      }

      if (responseKey != null) {
        _setResponseKey(responseKey);
      }

      allowLog = log;
      AppxsRestApiLogger.init();

      initializated = true;
    } catch (e) {
      throw AppxsRestApiException(code: 0);
    }
  }

  static Duration getRequestTimeout() {
    return _requestTimeout;
  }

  static String getProductDomain() {
    return _productDomain;
  }

  static String getDebugDomain() {
    return _debugDomain ?? _productDomain;
  }

  static String? getResponseKey() {
    return _responseKey;
  }

  static int? getPort() {
    return _port;
  }

  void _setRequestTimeout(Duration requestTimeout) {
    _requestTimeout = requestTimeout;
  }

  void _setProductionDomain(String productDomain) {
    _productDomain = productDomain;
  }

  void _setDebugDomain(String debugDomain) {
    _debugDomain = debugDomain;
  }

  void _setResponseKey(String responseKey) {
    _responseKey = responseKey;
  }

  void _setPort(int port) {
    _port = port;
  }
}
