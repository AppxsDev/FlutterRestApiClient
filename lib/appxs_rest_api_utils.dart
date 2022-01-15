import 'appxs_rest_api_config.dart';

class AppxsRestApiUtils {
  static Future<bool> hasConnection() async {
    return true;
  }

  static bool isAPIInitializated() {
    return AppxsRestApiConfig.initializated;
  }

  static Uri mountURL({required String endpoint, required bool isTest}) {
    String apiDomain = isTest
        ? AppxsRestApiConfig.getDebugDomain()
        : AppxsRestApiConfig.getProductDomain();

    if (AppxsRestApiConfig.getPort() != null) {
      return Uri.parse(
          apiDomain + ":" + AppxsRestApiConfig.getPort().toString() + endpoint);
    } else {
      return Uri.parse(apiDomain + endpoint);
    }
  }
}
