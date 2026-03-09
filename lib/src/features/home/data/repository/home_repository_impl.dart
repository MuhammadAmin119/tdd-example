import 'package:tdd_example/src/core/utils/either/either.dart';
import 'package:tdd_example/src/core/utils/failure/failure.dart';
import 'package:tdd_example/src/features/home/data/model/product_model.dart';
import 'package:tdd_example/src/features/home/data/source/home_source.dart';
import 'package:tdd_example/src/features/home/domain/repository/home_repository.dart';

class HomeRepositoryImpl extends HomeRepository {
  final HomeSource homeSource;

  HomeRepositoryImpl(this.homeSource);
  @override
  Future<Either<Failure, ProductModel>> getProducts() async {
    try {
      final result = await homeSource.getProducts();
      if (result.isRight) {
        return Right(result.right);
      } else {
        return Left(Failure());
      }
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
