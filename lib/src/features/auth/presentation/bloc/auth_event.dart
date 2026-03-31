abstract class AuthEvent {}

class AuthRegisterEvent extends AuthEvent {
  String username;
  String email;
  String password;
  AuthRegisterEvent({
    required this.username,
    required this.email,
    required this.password,
  });
}

class AuthLoginEvent extends AuthEvent {
  String username;
  String password;
  AuthLoginEvent({required this.password, required this.username});
}
