enum OtpStatus { initial, loading, verified, error }

class OtpState {
  final OtpStatus status;
  final String errorText;
  final int secondsLeft;

  const OtpState({
    this.status = OtpStatus.initial,
    this.errorText = '',
    this.secondsLeft = 30,
  });

  bool get isExpired => secondsLeft <= 0;
}