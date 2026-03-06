import 'package:tdd_example/src/core/utils/either/either.dart';
import 'package:tdd_example/src/core/utils/failure/failure.dart';
import 'package:tdd_example/src/features/auth/data/source/auth_source.dart';
import 'package:tdd_example/src/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
 final AuthSource authSource;

  AuthRepositoryImpl(this.authSource);

  @override
  Future<Either<Failure, String>> login({
    required Map<String, dynamic> userInfo,
  }) async {
    try {
      final result = await authSource.login(userInfo: userInfo);
      if (result.isRight) {
        return Right(result.right);
      } else {
        return Left(Failure());
      }
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> register({
    required Map<String, dynamic> userInfo,
  }) async {
    try {
      final result = await authSource.register(userInfo: userInfo);
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


