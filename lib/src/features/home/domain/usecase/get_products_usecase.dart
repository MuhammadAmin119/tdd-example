import 'package:tdd_example/src/core/utils/either/either.dart';
import 'package:tdd_example/src/core/utils/failure/failure.dart';
import 'package:tdd_example/src/core/utils/usecase/use_case.dart';
import 'package:tdd_example/src/features/home/data/model/product_model.dart';
import 'package:tdd_example/src/features/home/data/repository/home_repository_impl.dart';

class GetProductsUsecase extends UseCase<ProductModel, NoParams> {
  HomeRepositoryImpl homeRepositoryImpl;
  GetProductsUsecase(this.homeRepositoryImpl);
  @override
  Future<Either<Failure, ProductModel>> call(params) async{
    return await homeRepositoryImpl.getProducts();
  }
}
