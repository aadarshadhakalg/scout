import 'package:appwrite/models.dart';

sealed class AuthenticationState {}

class InitialAuthenticationState extends AuthenticationState {}

class NoAuthenticatedState extends AuthenticationState {}

class AuthenticatingState extends AuthenticationState {}

class OTPSentState extends AuthenticationState {
  final String uuid;

  OTPSentState(this.uuid);
}

class AuthenticatedState extends AuthenticationState {
  final User user;
  final Session session;

  AuthenticatedState(this.user, this.session);
}

class AuthenticationFailedState extends AuthenticationState {
  final String errorMessage;

  AuthenticationFailedState(this.errorMessage);
}
