import 'package:tdd_example/src/core/utils/either/either.dart';
import 'package:tdd_example/src/core/utils/failure/failure.dart';

abstract class OtpSource {
  Future<Either<Failure, String>> confirmOtp({
    required Map<String, dynamic> otp,
  });
}

