// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:konsulta_admin/core/features/authentication/data/repositories/authentication_impl.dart'
    as _i349;
import 'package:konsulta_admin/core/features/authentication/domain/repositories/authentication_repo.dart'
    as _i487;
import 'package:konsulta_admin/core/features/authentication/domain/use_case/auth_use_case.dart'
    as _i218;
import 'package:konsulta_admin/core/features/authentication/presentation/bloc/auth_bloc.dart'
    as _i988;
import 'package:konsulta_admin/core/features/onboarding_queue/data/datasources/onboarding_queue_service.dart'
    as _i350;
import 'package:konsulta_admin/core/features/onboarding_queue/data/repositories/onboarding_queue_repository_impl.dart'
    as _i482;
import 'package:konsulta_admin/core/features/onboarding_queue/domain/repositories/onboarding_queue_repository.dart'
    as _i209;
import 'package:konsulta_admin/core/features/onboarding_queue/domain/usecases/get_pending_applicants_usecase.dart'
    as _i844;
import 'package:konsulta_admin/core/features/onboarding_queue/domain/usecases/get_under_review_applicants_usecase.dart'
    as _i361;
import 'package:konsulta_admin/core/features/onboarding_queue/domain/usecases/start_review_usecase.dart'
    as _i556;
import 'package:konsulta_admin/core/features/onboarding_queue/domain/usecases/get_professional_tags_usecase.dart'
    as _i1001;
import 'package:konsulta_admin/core/features/onboarding_queue/presentation/bloc/onboarding_queue_bloc.dart'
    as _i908;
import 'package:konsulta_admin/core/service/api_service/konsulta_admin_api.dart'
    as _i999;
import 'package:konsulta_admin/core/service/config/config.dart' as _i667;
import 'package:konsulta_admin/core/service/config/config_model.dart' as _i950;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final configModule = _$ConfigModule();
    gh.factory<_i950.Config>(
      () => configModule.configDevInfinity,
      instanceName: 'devConfig',
    );
    gh.lazySingleton<_i350.OnboardingQueueService>(
      () => _i350.OnboardingQueueService(gh<_i999.KonsultaProApi>()),
    );
    gh.lazySingleton<_i999.KonsultaProApi>(
      () => _i999.KonsultaProApi(gh<_i950.Config>(instanceName: 'devConfig')),
    );
    gh.lazySingleton<_i209.OnboardingQueueRepository>(
      () => _i482.OnboardingQueueRepositoryImpl(
        gh<_i350.OnboardingQueueService>(),
      ),
    );
    gh.lazySingleton<_i487.AuthenticationRepo>(
      () => _i349.AuthenticationImpl(gh<_i999.KonsultaProApi>()),
    );
    gh.factory<_i218.AuthUseCase>(
      () => _i218.AuthUseCase(gh<_i487.AuthenticationRepo>()),
    );
    gh.lazySingleton<_i844.GetPendingApplicantsUseCase>(
      () => _i844.GetPendingApplicantsUseCase(
        gh<_i209.OnboardingQueueRepository>(),
      ),
    );
    gh.lazySingleton<_i361.GetUnderReviewApplicantsUseCase>(
      () => _i361.GetUnderReviewApplicantsUseCase(
        gh<_i209.OnboardingQueueRepository>(),
      ),
    );
    gh.lazySingleton<_i556.StartReviewUseCase>(
      () => _i556.StartReviewUseCase(gh<_i209.OnboardingQueueRepository>()),
    );
    gh.lazySingleton<_i1001.GetProfessionalTagsUseCase>(
      () => _i1001.GetProfessionalTagsUseCase(
        gh<_i209.OnboardingQueueRepository>(),
      ),
    );
    gh.lazySingleton<_i988.AuthBloc>(
      () => _i988.AuthBloc(gh<_i218.AuthUseCase>()),
    );
    gh.factory<_i908.OnboardingQueueBloc>(
      () => _i908.OnboardingQueueBloc(
        gh<_i844.GetPendingApplicantsUseCase>(),
        gh<_i361.GetUnderReviewApplicantsUseCase>(),
        gh<_i556.StartReviewUseCase>(),
        gh<_i1001.GetProfessionalTagsUseCase>(),
      ),
    );
    return this;
  }
}

class _$ConfigModule extends _i667.ConfigModule {}
