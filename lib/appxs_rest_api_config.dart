class AppxsRestApiConfig {
  final Duration requestTimeout;
  final String productDomain;
  final String? debugDomain;
  final String? responseKey;
  final int? port;

  bool isInitializated = false;
  bool allowLog = false;

  AppxsRestApiConfig.init({
    required this.productDomain,
    required this.requestTimeout,
    this.allowLog = false,
    this.port,
    this.responseKey,
    this.debugDomain,
  }) : isInitializated = true;
}
