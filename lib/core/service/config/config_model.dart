class Config {
  const Config({
    required this.apiBasePath,
    required this.apiDomain,
    this.apiPort,
    this.urlType,
    this.apiUseHttps = true, 
  });

  final String apiDomain;
  final String apiBasePath;
  final String? urlType;
  final int? apiPort;
  final bool apiUseHttps; 
}

class AuthOtpConfig {
  static const String purpose = 'registration';
  static const String forgotPasswordPurpose = 'PASSWORD_RESET';
  static const String channel = 'sms';
  static const String channelUpperCase = 'SMS';
  static const String prefix = '+63';
}

