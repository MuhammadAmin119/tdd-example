import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tdd_example/src/features/auth/presentation/cubit/auht_cubit.dart';
import '../cubit/auth_state.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    var primaryColor = Colors.blue;
    var accentColor = Colors.orange;

    var backgroundColor = isDark ? Color(0xFF121212) : Color(0xFFF5F6FA);

    var cardColor = isDark ? Color(0xFF1E1E1E) : Colors.white;

    var textColor = isDark ? Colors.white : Colors.black87;

    var hintColor = isDark ? Colors.white60 : Colors.black54;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authentificated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: primaryColor,
                content: Text(
                  'Login successful!',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }

          if (state.status == AuthStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: accentColor,
                content: Text(
                  state.errorText,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Flowerfly',
                    style: GoogleFonts.merriweather(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),

                  SizedBox(height: 40),
                  TextField(
                    controller: _usernameController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'UserName',
                      labelStyle: TextStyle(color: hintColor),
                      filled: true,
                      fillColor: isDark ? Color(0xFF2A2A2A) : Color(0xFFF0F2F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: hintColor),
                      filled: true,
                      fillColor: isDark ? Color(0xFF2A2A2A) : Color(0xFFF0F2F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                    ),
                  ),

                  SizedBox(height: 30),

                  context.read<AuthCubit>().state.status == AuthStatus.loading
                      ? CircularProgressIndicator(color: primaryColor)
                      : SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<AuthCubit>().login(
                                username: _usernameController.text.trim(),
                                password: _passwordController.text.trim(),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
