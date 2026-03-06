import 'package:tdd_example/src/core/utils/either/either.dart';
import 'package:tdd_example/src/core/utils/failure/failure.dart';
import 'package:tdd_example/src/features/otp/data/source/otp_source.dart';
import 'package:tdd_example/src/features/otp/domain/repository/otp_repository.dart';

class OtpRepositoryImpl extends OtpRepository {
  final OtpSource otpSource;

  OtpRepositoryImpl(this.otpSource);

  @override
  Future<Either<Failure, String>> confirmOtp({
    required Map<String, dynamic> otp,
  }) async {
    try {
      final result = await otpSource.confirmOtp(otp: otp);
      if (result.isRight) {
        return Right(result.right);
      } else {
        return Left(Failure(message: result.left.message));
      }
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}

