import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_example/src/core/utils/services/storage_service.dart';
import 'package:tdd_example/src/features/auth/domain/usecase/auth_login_usecase.dart';
import 'package:tdd_example/src/features/auth/domain/usecase/auth_register_usecase.dart';
import 'package:tdd_example/src/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRegisterUsecase authRegisterUsecase;
  final AuthLoginUsecase authLoginUsecase;

  AuthCubit({required this.authRegisterUsecase, required this.authLoginUsecase})
    : super(AuthState(status: AuthStatus.intial));

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
        await StorageService.write('pendingOtp', result.right);
        await StorageService.write('pendingEmail', email);
        emit(AuthState(status: AuthStatus.authentificated));
      } else {
        throw Exception();
      }
    } on TimeoutException catch (_) {
      emit(
        AuthState(
          status: AuthStatus.error,
          errorText: 'Server is down or slow connection !',
        ),
      );
    } on SocketException catch (_) {
      emit(
        AuthState(
          status: AuthStatus.error,
          errorText: 'No internet connection !',
        ),
      );
    } on DioException catch (e) {
      emit(AuthState(status: AuthStatus.error, errorText: e.toString()));
    } catch (e, stack) {
      print('haay xatolik bor catch da -------$e');
      print('haay xatolik bor catch da -------$stack');

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
        await StorageService.write('access', result.right);
        emit(AuthState(status: AuthStatus.authentificated));
      } else {
        emit(
          AuthState(
            status: AuthStatus.error,
            errorText: result.left.message,
            //  result.left.message.isEmpty ? 'Login failed' : ,
          ),
        );
      }
    } on TimeoutException catch (_) {
      emit(
        AuthState(
          status: AuthStatus.error,
          errorText: 'Server is down or slow connection !',
        ),
      );
    } on SocketException catch (_) {
      emit(
        AuthState(
          status: AuthStatus.error,
          errorText: 'No internet connection !',
        ),
      );
    } on DioException catch (e) {
      emit(AuthState(status: AuthStatus.error, errorText: e.toString()));
    } catch (e) {
      emit(AuthState(status: AuthStatus.error, errorText: e.toString()));
    }
  }
}
