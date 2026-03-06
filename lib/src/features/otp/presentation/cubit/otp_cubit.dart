import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_example/src/features/otp/domain/usecase/otp_confirm_usecase.dart';
import 'package:tdd_example/src/features/otp/presentation/cubit/otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final OtpConfirmUsecase otpConfirmUsecase;
  Timer? _timer;

  OtpCubit({required this.otpConfirmUsecase}) : super(const OtpState()) {
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    emit(OtpState(
      status: OtpStatus.initial,
      errorText: '',
      secondsLeft: 60,
    ));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.secondsLeft <= 0) {
        timer.cancel();
        return;
      }
      emit(OtpState(
        status: state.status,
        errorText: state.errorText,
        secondsLeft: state.secondsLeft - 1,
      ));
    });
  }

  Future<void> confirmOtp({
    required String email,
    required String code,
  }) async {
    if (state.isExpired) {
      emit(OtpState(
        status: OtpStatus.error,
        errorText: 'OTP expired. Please restart the timer.',
        secondsLeft: state.secondsLeft,
      ));
      return;
    }

    emit(OtpState(
      status: OtpStatus.loading,
      errorText: '',
      secondsLeft: state.secondsLeft,
    ));

    final result = await otpConfirmUsecase.call({
      'email': email,
      'code': code,
    });

    if (result.isRight) {
      emit(OtpState(
        status: OtpStatus.verified,
        errorText: '',
        secondsLeft: state.secondsLeft,
      ));
    } else {
      emit(OtpState(
        status: OtpStatus.error,
        errorText: result.left.message,
        secondsLeft: state.secondsLeft,
      ));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}