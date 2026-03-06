import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_example/src/core/utils/services/storage_service.dart';
import 'package:tdd_example/src/features/auth/data/repository/auth_repository_impl.dart';
import 'package:tdd_example/src/features/auth/data/source/auth_source_impl.dart';
import 'package:tdd_example/src/features/auth/domain/usecase/auth_login_usecase.dart';
import 'package:tdd_example/src/features/auth/domain/usecase/auth_register_usecase.dart';
import 'package:tdd_example/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tdd_example/src/features/auth/presentation/screens/login_screen.dart';
import 'package:tdd_example/src/features/auth/presentation/screens/register_screen.dart';
import 'package:tdd_example/src/features/home/screens/home_screen.dart';
import 'package:tdd_example/src/features/otp/data/repository/otp_repository_impl.dart';
import 'package:tdd_example/src/features/otp/data/source/otp_source_impl.dart';
import 'package:tdd_example/src/features/otp/domain/usecase/otp_confirm_usecase.dart';
import 'package:tdd_example/src/features/otp/presentation/cubit/otp_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(
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
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fintech Platform',
      theme: ThemeData(colorScheme:  ColorScheme.light(primary: Colors.blue)),
      home:  LoginScreen() //  StorageService.read('access') != null
          // ?  HomeScreen()
          // :  LoginScreen(),
    );
  }
}
