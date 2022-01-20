// ignore_for_file: avoid_print

import 'package:logger/logger.dart';

import 'appxs_rest_api_config.dart';

class AppxsRestApiLogger {
  static late Logger logger;

  AppxsRestApiLogger.init() {
    logger = Logger(
        level: Level.debug,
        printer: PrettyPrinter(
            noBoxingByDefault: true,
            methodCount: 0,
            errorMethodCount: 5,
            lineLength: 50,
            colors: true,
            printEmojis: false,
            printTime: false));
  }

  static void log(Level level, String message) {
    if (AppxsRestApiConfig.allowLog) {
      logger.log(level, "│ " + message);
    }
  }

  static void openBox() {
    if (AppxsRestApiConfig.allowLog) {
      print("┌─────────────────────────────────────────────────");
    }
  }

  static void closeBox() {
    if (AppxsRestApiConfig.allowLog) {
      print("└─────────────────────────────────────────────────");
    }
  }
}
