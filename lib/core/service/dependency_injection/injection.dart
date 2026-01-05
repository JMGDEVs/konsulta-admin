import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:konsulta_admin/core/service/dependency_injection/injection.config.dart';

final sl = GetIt.instance;

@injectableInit
Future<void> configureDependencies() async => sl.init();
