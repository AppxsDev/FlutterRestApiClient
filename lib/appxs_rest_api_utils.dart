import 'appxs_rest_api_config.dart';

class AppxsRestApiUtils {
  static Future<bool> hasConnection() async {
    return true;
  }

  static Uri mountURL(
      {required AppxsRestApiConfig config,
      required String endpoint,
      required bool isTest}) {
    String apiDomain = isTest
        ? config.debugDomain ?? config.productDomain
        : config.productDomain;

    if (config.port != null) {
      return Uri.parse(apiDomain + ":" + config.port.toString() + endpoint);
    } else {
      return Uri.parse(apiDomain + endpoint);
    }
  }
}
