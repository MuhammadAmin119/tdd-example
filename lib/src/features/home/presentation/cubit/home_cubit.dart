import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_example/src/core/utils/usecase/use_case.dart';
import 'package:tdd_example/src/features/home/domain/usecase/get_products_usecase.dart';
import 'package:tdd_example/src/features/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetProductsUsecase getProductsUsecase;

  HomeCubit({required this.getProductsUsecase}) : super(HomeState());

  Future<void> getProducts() async {
    try {
      emit(HomeState(status: HomeStatus.loading));
      final result = await getProductsUsecase.call(NoParams());
      if (result.isRight) {
        print('CUBIT SUCCESS: ${result.right}');
        emit(HomeState(status: HomeStatus.success, products: result.right));
      } else {
        print('CUBIT ERROR: ${result.left.message}');
        emit(
          HomeState(status: HomeStatus.error, errorText: result.left.message),
        );
      }
    } on TimeoutException catch (_) {
      emit(
        HomeState(
          status: HomeStatus.error,
          errorText: 'Server is down or slow connection!',
        ),
      );
    } on SocketException catch (_) {
      emit(
        HomeState(
          status: HomeStatus.error,
          errorText: 'No internet connection!',
        ),
      );
    } on DioException catch (e) {
      emit(
        HomeState(
          status: HomeStatus.error,
          errorText: e.message ?? 'Something went wrong',
        ),
      );
    } catch (e, stack) {
      print('ERROR: $e');
      print('STACK: $stack');
      emit(HomeState(status: HomeStatus.error, errorText: e.toString()));
    }
  }
}