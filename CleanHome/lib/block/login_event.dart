part of 'login_bloc.dart';
abstract class LoginEvent{
  const LoginEvent();
}
class LoginChangeStatusEvent extends LoginEvent{
  final bool login;
  LoginChangeStatusEvent(this.login);
}