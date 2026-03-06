class AuthState {
  AuthStatus status;
  String errorText;
  AuthState({this.status = AuthStatus.initial, this.errorText = "", });
}

enum AuthStatus { initial, loading, error, authentificated }
