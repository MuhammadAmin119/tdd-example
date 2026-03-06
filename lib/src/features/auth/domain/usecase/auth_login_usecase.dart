import 'package:tdd_example/src/core/utils/either/either.dart';
import 'package:tdd_example/src/core/utils/failure/failure.dart';
import 'package:tdd_example/src/core/utils/usecase/use_case.dart';
import 'package:tdd_example/src/features/auth/domain/repository/auth_repository.dart';

class AuthLoginUsecase extends UseCase<String, Map<String, dynamic>> {
  final AuthRepository authRepository;
  AuthLoginUsecase({required this.authRepository});

  @override
  Future<Either<Failure, String>> call(Map<String, dynamic> params) {
    return authRepository.login(userInfo: params);
  }
}

