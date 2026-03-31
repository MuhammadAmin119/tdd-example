import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_example/src/features/auth/domain/usecase/auth_login_usecase.dart';
import 'package:tdd_example/src/features/auth/domain/usecase/auth_register_usecase.dart';
import 'package:tdd_example/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:tdd_example/src/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRegisterUsecase authRegisterUsecase;
  final AuthLoginUsecase authLoginUsecase;

  AuthBloc({required this.authRegisterUsecase, required this.authLoginUsecase})
    : super(AuthState()) {
    on<AuthRegisterEvent>((event, emit) async {
      try {
        emit(AuthState(status: AuthStatus.loading));
        final result = await authRegisterUsecase.call({
          "username": event.username,
          "email": event.email,
          "password": event.password,
        });

        if (result.isRight) {
          print('OTP code ${result.right}');
          emit(AuthState(status: AuthStatus.codeSent));
        } else {
          emit(
            AuthState(status: AuthStatus.error, errorText: result.left.message),
          );
        }
      } on TimeoutException catch (_) {
        emit(
          AuthState(
            status: AuthStatus.error,
            errorText: 'Server is down or slow connection!',
          ),
        );
      } on SocketException catch (_) {
        emit(
          AuthState(
            status: AuthStatus.error,
            errorText: 'No internet connection!',
          ),
        );
      } on DioException catch (e) {
        emit(AuthState(status: AuthStatus.error, errorText: e.toString()));
      } catch (e, stack) {
        print('xatolik: $e');
        print('stack: $stack');
        emit(AuthState(status: AuthStatus.error, errorText: e.toString()));
      }
    });

    on<AuthLoginEvent>((event, emit) async {
      try {
        emit(AuthState(status: AuthStatus.loading));
        final result = await authLoginUsecase.call({
          "username": event.username,
          "password": event.password,
        });

        if (result.isRight) {
          emit(AuthState(status: AuthStatus.codeSent));
        } else {
          emit(
            AuthState(status: AuthStatus.error, errorText: result.left.message),
          );
        }
      } on TimeoutException catch (_) {
        emit(
          AuthState(
            status: AuthStatus.error,
            errorText: 'Server is down or slow connection!',
          ),
        );
      } on SocketException catch (_) {
        emit(
          AuthState(
            status: AuthStatus.error,
            errorText: 'No internet connection!',
          ),
        );
      } on DioException catch (e) {
        emit(AuthState(status: AuthStatus.error, errorText: e.toString()));
      } catch (e) {
        emit(AuthState(status: AuthStatus.error, errorText: e.toString()));
      }
    });
  }
}
