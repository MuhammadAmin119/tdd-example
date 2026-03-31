import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tdd_example/main.dart';
import 'package:tdd_example/src/core/config/dio_config.dart';
import 'package:tdd_example/src/core/utils/either/either.dart';
import 'package:tdd_example/src/core/utils/failure/failure.dart';
import 'package:tdd_example/src/core/utils/services/storage_service.dart';
import 'package:tdd_example/src/features/auth/data/source/auth_source.dart';
import 'package:toastification/toastification.dart';

class AuthSourceImpl extends AuthSource {
  @override
  Future<Either<Failure, String>> login({
    required Map<String, dynamic> userInfo,
  }) async {
    print('🔐 [login] START — userInfo: $userInfo');
    try {
      print('📡 [login] Sending POST to /api-service.fintechhub.uz/login/...');

      final Response response = await DioConfig.client.post(
        '/login/',
        data: userInfo,
      );
      print(
        '📥 [login] Response received — status: ${response.statusCode}, data: ${response.data}',
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        print(
          '✅ [login] SUCCESS — status: ${response.statusCode}, body: ${response.data}',
        );

        StorageService.write('refresh', response.data['tokens']['access']);
        StorageService.write('access', response.data['tokens']['refresh']);

        return Right(response.data['tokens']);
      } else {
        print(
          '❌ [login] FAILED — status: ${response.statusCode}, body: ${response.data}',
        );
        throw DioException(requestOptions: response.requestOptions);
      }
    } on TimeoutException catch (e) {
      return Left(
        Failure(message: e.message ?? 'Time is up or server is down'),
      );
    } on SocketException catch (e) {
      return Left(Failure(message: e.message));
    } on DioException catch (e) {
      return Left(Failure(message: e.message ?? 'Something went wrong'));
    } catch (e) {
      return Left(Failure(message: 'Somethink went wrong'));
    }
  }

  @override
  Future<Either<Failure, String>> register({
    required Map<String, dynamic> userInfo,
  }) async {
    try {
      print('🔐 [register] START — userInfo: $userInfo');
      final response = await DioConfig.client.post(
        '/register/',
        data: userInfo,
      );
      print(
        '📥 [register] Response received — status: ${response.statusCode}, data: ${response.data}',
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        print(
          '✅ [register] SUCCESS — status: ${response.statusCode}, body: ${response.data}',
        );
        toastification.show(
          context: globalKey.currentContext,
          type: ToastificationType.info,
          title: Text('Your code :${response.data['otp']},'),
          autoCloseDuration:  Duration(seconds: 7),
        );
        return Right(response.data['otp']);
      } else {
        print(
          '❌ [register] FAILED — status: ${response.statusCode}, body: ${response.data}',
        );
        throw DioException(requestOptions: response.requestOptions);
      }
    } on TimeoutException catch (e) {
      return Left(
        Failure(message: e.message ?? 'Time is up or server is down'),
      );
    } on SocketException catch (e) {
      return Left(Failure(message: e.message));
    } on DioException catch (e) {
      return Left(Failure(message: e.message ?? 'Something went wrong'));
    } catch (e) {
      return Left(Failure(message: 'Somethink went wrong'));
    }
  }
}
