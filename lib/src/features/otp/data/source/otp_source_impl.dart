import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:tdd_example/src/core/utils/either/either.dart';
import 'package:tdd_example/src/core/utils/failure/failure.dart';
import 'package:tdd_example/src/core/utils/services/storage_service.dart';
import 'package:tdd_example/src/features/otp/data/source/otp_source.dart';

class OtpSourceImpl extends OtpSource {
  final Dio client;

  OtpSourceImpl({Dio? client}) : client = client ?? Dio();

  @override
  Future<Either<Failure, String>> confirmOtp({
    required Map<String, dynamic> otp,
  }) async {
    print('┌─────────────────────────────────────────');
    print('│ [OtpSource] confirmOtp() called');
    print('│ [OtpSource] Raw input → $otp');

    final String email = otp['email'].toString().replaceAll(' ', '');
    final int code = int.parse(otp['code'].toString());

    print('│ [OtpSource] Parsed email → $email');
    print('│ [OtpSource] Parsed code  → $code');
    print('│ [OtpSource] Sending POST → https://api-service.fintechhub.uz/otp-verify/');
    print('└─────────────────────────────────────────');

    try {
      final response = await client.post(
        'https://api-service.fintechhub.uz/otp-verify/',
        data: {
          "email": email,
          "code": code,
        },
      );

      print('┌─────────────────────────────────────────');
      print('│ [OtpSource] Response received');
      print('│ [OtpSource] Status code → ${response.statusCode}');
      print('│ [OtpSource] Response data → ${response.data}');
      print('└─────────────────────────────────────────');

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        print('┌─────────────────────────────────────────');
        print('│ [OtpSource] ✅ Success — saving tokens');
        print('│ [OtpSource] Access token  → ${response.data['tokens']['access']}');
        print('│ [OtpSource] Refresh token → ${response.data['tokens']['refresh']}');
        print('└─────────────────────────────────────────');

        StorageService.write('refresh', response.data['tokens']['refresh']);
        StorageService.write('access', response.data['tokens']['access']);

        print('[OtpSource] ✅ Tokens saved to StorageService successfully');
        return Right('success');
      }

      print('[OtpSource] ❌ Unexpected status code → ${response.statusCode}');
      throw DioException(requestOptions: response.requestOptions);

    } on TimeoutException catch (e) {
      print('┌─────────────────────────────────────────');
      print('│ [OtpSource] ⏱ TimeoutException caught');
      print('│ [OtpSource] Message → ${e.message}');
      print('└─────────────────────────────────────────');
      return Left(Failure(message: e.message ?? 'Time is up or server is down'));

    } on SocketException catch (e) {
      print('┌─────────────────────────────────────────');
      print('│ [OtpSource] 🌐 SocketException caught');
      print('│ [OtpSource] Message → ${e.message}');
      print('└─────────────────────────────────────────');
      return Left(Failure(message: e.message));

    } on DioException catch (e) {
      print('┌─────────────────────────────────────────');
      print('│ [OtpSource] 🔴 DioException caught');
      print('│ [OtpSource] Status code → ${e.response?.statusCode}');
      print('│ [OtpSource] Response data → ${e.response?.data}');
      print('│ [OtpSource] Message → ${e.message}');
      print('└─────────────────────────────────────────');
      return Left(Failure(message: e.message ?? 'Something went wrong'));

    } catch (e) {
      print('┌─────────────────────────────────────────');
      print('│ [OtpSource] 💥 Unknown error caught');
      print('│ [OtpSource] Error → $e');
      print('└─────────────────────────────────────────');
      return Left(Failure(message: 'Something went wrong'));
    }
  }
}