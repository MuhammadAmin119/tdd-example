import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_example/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tdd_example/src/features/home/data/repository/home_repository_impl.dart';
import 'package:tdd_example/src/features/home/data/source/home_source_impl.dart';
import 'package:tdd_example/src/features/home/domain/usecase/get_products_usecase.dart';
import 'package:tdd_example/src/features/home/presentation/cubit/home_cubit.dart';
import 'package:toastification/toastification.dart';
import 'package:tdd_example/src/core/utils/services/storage_service.dart';
import 'package:tdd_example/src/features/auth/data/repository/auth_repository_impl.dart';
import 'package:tdd_example/src/features/auth/data/source/auth_source_impl.dart';
import 'package:tdd_example/src/features/auth/domain/usecase/auth_login_usecase.dart';
import 'package:tdd_example/src/features/auth/domain/usecase/auth_register_usecase.dart';
import 'package:tdd_example/src/features/auth/presentation/screens/login_screen.dart';
import 'package:tdd_example/src/features/home/presentation/screens/home_screen.dart';
import 'package:tdd_example/src/features/otp/data/repository/otp_repository_impl.dart';
import 'package:tdd_example/src/features/otp/data/source/otp_source_impl.dart';
import 'package:tdd_example/src/features/otp/domain/usecase/otp_confirm_usecase.dart';
import 'package:tdd_example/src/features/otp/presentation/cubit/otp_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            authRegisterUsecase: AuthRegisterUsecase(
              authRepository: AuthRepositoryImpl(AuthSourceImpl()),
            ),

            authLoginUsecase: AuthLoginUsecase(
              authRepository: AuthRepositoryImpl(AuthSourceImpl()),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => OtpCubit(
            otpConfirmUsecase: OtpConfirmUsecase(
              otpRepository: OtpRepositoryImpl(OtpSourceImpl()),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => HomeCubit(
            getProductsUsecase: GetProductsUsecase(
              homeRepositoryImpl: HomeRepositoryImpl(HomeSourceImpl()),
            ),
          ),
        ),
      ],
      child: ToastificationWrapper(
        child: MaterialApp(
          title: 'Fintech Platform',
          theme: ThemeData(
            colorScheme: ColorScheme.light(primary: Colors.blue),
          ),
          home: StorageService.read('access') != null
              ? HomeScreen()
              : LoginScreen(),
        ),
      ),
    );
  }
}
