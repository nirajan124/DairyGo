import 'package:get_it/get_it.dart';

import '../../features/auth/data/data_source/user_data_source.dart';
import '../../features/auth/data/repository/local_repository/user_local_repository.dart';
import '../../features/auth/domain/repository/user_repository.dart';
import '../../features/auth/domain/use_case/user_login_usecase.dart';
import '../../features/auth/domain/use_case/user_register_usecase.dart';
import '../../features/auth/presentation/view_model/login_viewmodel/login_viewmodel.dart';
import '../../features/auth/presentation/view_model/signup_viewmodel/signup_viewmodel.dart';
import '../../features/home/presentation/view_model/homepage_viewmodel.dart';
import '../../features/splash/presentation/view_model/splash_viewmodel.dart';

final serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  await _initAuthModule();
  await _initHomeModule();
}

Future<void> _initAuthModule() async {
  serviceLocator.registerLazySingleton<IUserDataSource>(
    () => UserLocalRepository(
      dataSource: serviceLocator<IUserDataSource>(),
    ),
  );

  serviceLocator.registerLazySingleton<IUserRepository>(
    () => UserLocalRepository(
      dataSource: serviceLocator<IUserDataSource>(),
    ),
  );

  serviceLocator.registerLazySingleton<UserLoginUsecase>(
    () => UserLoginUsecase(
      userRepository: serviceLocator<IUserRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<UserRegisterUsecase>(
    () => UserRegisterUsecase(
      userRepository: serviceLocator<IUserRepository>(),
    ),
  );

  serviceLocator.registerFactory<LoginViewModel>(
    () => LoginViewModel(
      userLoginUsecase: serviceLocator<UserLoginUsecase>(),
    ),
  );

  serviceLocator.registerFactory<SignupViewModel>(
    () => SignupViewModel(
      userRegisterUsecase: serviceLocator<UserRegisterUsecase>(),
    ),
  );
}

Future<void> _initSplashModule() async {
  // If SplashViewModel has dependencies, inject them here
  serviceLocator.registerFactory<SplashViewModel>(
    () => SplashViewModel(),
  );
}

Future<void> _initHomeModule() async {
  // If HomePageViewModel has dependencies, inject them here
  serviceLocator.registerFactory<HomeViewModel>(
    () => HomeViewModel(),
  );
}
