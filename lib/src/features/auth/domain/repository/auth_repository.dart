import 'package:tdd_example/src/core/utils/either/either.dart';
import 'package:tdd_example/src/core/utils/failure/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> register({
    required Map<String, dynamic> userInfo,
  });
  Future<Either<Failure, String>> login({
    required Map<String, dynamic> userInfo,
  });
}
