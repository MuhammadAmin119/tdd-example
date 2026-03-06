import 'package:tdd_example/src/core/utils/either/either.dart';
import 'package:tdd_example/src/core/utils/failure/failure.dart';
import 'package:tdd_example/src/core/utils/usecase/use_case.dart';
import 'package:tdd_example/src/features/otp/domain/repository/otp_repository.dart';

class OtpConfirmUsecase extends UseCase<String, Map<String, dynamic>> {
  final OtpRepository otpRepository;
  OtpConfirmUsecase({required this.otpRepository});

  @override
  Future<Either<Failure, String>> call(Map<String, dynamic> params) {
    return otpRepository.confirmOtp(otp: params);
  }
}

