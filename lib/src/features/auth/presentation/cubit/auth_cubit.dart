import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_example/src/features/auth/domain/usecase/auth_login_usecase.dart';
import 'package:tdd_example/src/features/auth/domain/usecase/auth_register_usecase.dart';
import 'package:tdd_example/src/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRegisterUsecase authRegisterUsecase;
  final AuthLoginUsecase authLoginUsecase;

  AuthCubit({required this.authRegisterUsecase, required this.authLoginUsecase})
      : super(AuthState(status: AuthStatus.initial));

  Future<void> register({
    required String username,
    required String password,
    required String email,
  }) async {
    try {
      emit(AuthState(status: AuthStatus.loading));
      final result = await authRegisterUsecase.call({
        "username": username,
        "email": email,
        "password": password,
      });

      if (result.isRight) {
        print('OTP code ${result.right}');
        emit(AuthState(status: AuthStatus.authentificated));
      } else {
        emit(AuthState(
          status: AuthStatus.error,
          errorText: result.left.message,
        ));
      }
    } on TimeoutException catch (_) {
      emit(AuthState(status: AuthStatus.error, errorText: 'Server is down or slow connection!'));
    } on SocketException catch (_) {
      emit(AuthState(status: AuthStatus.error, errorText: 'No internet connection!'));
    } on DioException catch (e) {
      emit(AuthState(status: AuthStatus.error, errorText: e.toString()));
    } catch (e, stack) {
      print('xatolik: $e');
      print('stack: $stack');
      emit(AuthState(status: AuthStatus.error, errorText: e.toString()));
    }
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    try {
      emit(AuthState(status: AuthStatus.loading));
      final result = await authLoginUsecase.call({
        "username": username,
        "password": password,
      });

      if (result.isRight) {
        emit(AuthState(status: AuthStatus.authentificated));
      } else {
        emit(AuthState(
          status: AuthStatus.error,
          errorText: result.left.message,
        ));
      }
    } on TimeoutException catch (_) {
      emit(AuthState(status: AuthStatus.error, errorText: 'Server is down or slow connection!'));
    } on SocketException catch (_) {
      emit(AuthState(status: AuthStatus.error, errorText: 'No internet connection!'));
    } on DioException catch (e) {
      emit(AuthState(status: AuthStatus.error, errorText: e.toString()));
    } catch (e) {
      emit(AuthState(status: AuthStatus.error, errorText: e.toString()));
    }
  }
}