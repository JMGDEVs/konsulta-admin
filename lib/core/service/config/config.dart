import 'package:injectable/injectable.dart';
import 'package:konsulta_admin/core/service/config/config_model.dart';

@module
abstract class ConfigModule {
  @Named('devConfig')
  Config get configDevInfinity => const Config(
    apiBasePath: '/api/admin',
    apiDomain: 'api2.geekogosolutions.com',
    apiPort: null,
    apiUseHttps: true,
    urlType: 'dev',
  );
}
