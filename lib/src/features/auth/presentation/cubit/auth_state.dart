class AuthState {
  AuthStatus status;
  String errorText;
  AuthState({this.status = AuthStatus.intial, this.errorText = "", });
}

enum AuthStatus { intial, loading, error, authentificated }
