import 'package:tdd_example/src/core/utils/either/either.dart';
import 'package:tdd_example/src/core/utils/failure/failure.dart';
import 'package:tdd_example/src/core/utils/usecase/use_case.dart';
import 'package:tdd_example/src/features/auth/domain/repository/auth_repository.dart';

class AuthRegisterUsecase extends UseCase<String, Map<String, dynamic>> {
  AuthRepository authRepository;
  AuthRegisterUsecase({required this.authRepository});

  @override
  Future<Either<Failure, String>> call(Map<String, dynamic> params) {
    return authRepository.register(userInfo: params);
  }
}
