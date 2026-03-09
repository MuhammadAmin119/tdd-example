import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:tdd_example/src/core/config/dio_config.dart';
import 'package:tdd_example/src/core/utils/either/either.dart';
import 'package:tdd_example/src/core/utils/failure/failure.dart';
import 'package:tdd_example/src/features/home/data/model/product_model.dart';
import 'package:tdd_example/src/features/home/data/source/home_source.dart';

class HomeSourceImpl extends HomeSource {
  
  @override
  Future<Either<Failure, ProductModel>> getProducts() async {
    try {
      final res = await DioConfig.client.get('/products/');
      print('STATUS: ${res.statusCode} | DATA: ${res.data}');
      if (res.statusCode! >= 200 && res.statusCode! < 300) {
        return Right(res.data);
      } else {
        throw DioException(requestOptions: res.requestOptions);
      }
    } on TimeoutException catch (e) {
      print('TIMEOUT: ${e.message}');
      return Left(Failure(message: e.message ?? 'Server is down or slow connection !'));
    } on SocketException catch (e) {
      print('SOCKET: ${e.message}');
      return Left(Failure(message: e.message));
    } on DioException catch (e) {
      print('DIO ERROR: ${e.message}');
      return Left(Failure(message: e.message ?? 'Something went wrong'));
    } catch (e) {
      print('ERROR: $e');
      return Left(Failure(message: 'Something went wrong !'));
    }
  }
}
