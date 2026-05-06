abstract base class LoginState {
  final String title;
  final bool logged;

  LoginState({
    this.title = 'Login',
    this.logged = false,
  });

}

final class LoginInitialState extends LoginState {
  LoginInitialState() : super(title: 'Login', logged: false);
}

final class LoginLoadingState extends LoginState {
  LoginLoadingState() : super(title: 'Logging in...', logged: false);
}

final class LoginCheckingCacheState extends LoginState {
  LoginCheckingCacheState() : super(title: 'Verificando sesión...', logged: false);
}

final class LoginSuccessState extends LoginState {
  final String username;
  LoginSuccessState(this.username)
    : super(title: 'Bienvenido, $username!', logged: true);
}

final class LoginErrorState extends LoginState {
  final String errorMessage;
  LoginErrorState(this.errorMessage)
    : super(title: 'Error al hacer login', logged: false);
}