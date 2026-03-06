import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:tdd_example/src/features/home/screens/home_screen.dart';
import 'package:tdd_example/src/features/otp/presentation/cubit/otp_cubit.dart';
import 'package:tdd_example/src/features/otp/presentation/cubit/otp_state.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('OTP Verification')),
      body: BlocConsumer<OtpCubit, OtpState>(
        listener: (context, state) {
          if (state.status == OtpStatus.error) {
            _pinController.clear();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorText.isEmpty
                      ? 'OTP verification failed'
                      : state.errorText,
                ),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state.status == OtpStatus.verified) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen()),
              (_) => false,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('OTP verified successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<OtpCubit>();
          final isLoading = state.status == OtpStatus.loading;
          final Color borderColor = state.isExpired ? Colors.red : Colors.green;

          final pinTheme = PinTheme(
            width: 52,
            height: 56,
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 2),
            ),
          );

          return Stack(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Enter the 6-digit code',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        state.isExpired
                            ? 'Code expired'
                            : 'Time left: 00:${state.secondsLeft.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 14,
                          color: state.isExpired ? Colors.red : Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 22),
                      Pinput(
                        controller: _pinController,
                        length: 6,
                        enabled: !isLoading && !state.isExpired,
                        defaultPinTheme: pinTheme,
                        focusedPinTheme: pinTheme,
                        submittedPinTheme: pinTheme,
                        onCompleted: (pin) =>
                            cubit.confirmOtp(email: widget.email, code: pin),
                      ),
                      SizedBox(height: 18),
                      TextButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                _pinController.clear();
                                cubit.startTimer();
                                cubit.confirmOtp(
                                  email: widget.email,
                                  code: _pinController.text,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Code was sent again! '),
                                    backgroundColor: Colors.green,

                                  ),
                                );
                              },
                        child: Text('Restart timer'),
                      ),
                    ],
                  ),
                ),
              ),
              if (isLoading)
                Positioned.fill(
                  child: AbsorbPointer(
                    child: Container(
                      color: Colors.black.withOpacity(0.25),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
