part of 'login_bloc.dart';
abstract class LoginState{
  const LoginState();
}
class LoginLoaded extends LoginState{
  final bool login;

  LoginLoaded(this.login);
}