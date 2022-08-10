part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

// When the user signing in with email and password this event is called and the [AuthRepository] is called to sign in the user
class SignInRequested extends AuthEvent {
  final String email;
  final String password;
  final bool storeCredentials;

  SignInRequested(this.email, this.password, this.storeCredentials);
}

// When the user signing up with email and password this event is called and the [AuthenticationService] is called to sign up the user
class SignUpRequested extends AuthEvent {
  final String email;
  final String password;

  SignUpRequested(this.email, this.password);
}

class PersistedAuthRequested extends AuthEvent {}

// When the user signing out this event is called and the [AuthenticationService] is called to sign out the user
class SignOutRequested extends AuthEvent {}

// Checks if a user is signed in
class InitRequested extends AuthEvent {}
