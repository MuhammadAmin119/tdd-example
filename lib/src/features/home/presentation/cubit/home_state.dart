import 'package:tdd_example/src/features/home/data/model/product_model.dart';

enum HomeStatus { initial, loading, success, error }

class HomeState {
  final HomeStatus status;
  final ProductModel? products;
  final String? errorText;

  HomeState({this.status = HomeStatus.initial, this.products, this.errorText});
}
