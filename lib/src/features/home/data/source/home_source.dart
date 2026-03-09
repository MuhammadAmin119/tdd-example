import 'package:tdd_example/src/core/utils/either/either.dart';
import 'package:tdd_example/src/core/utils/failure/failure.dart';
import 'package:tdd_example/src/features/home/data/model/product_model.dart';

abstract class HomeSource {
  Future<Either<Failure, ProductModel>> getProducts();
}
