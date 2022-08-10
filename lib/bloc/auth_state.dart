part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

// When the user presses the signin or signup button the state is changed to loading first and then to Authenticated.
class Loading extends AuthState {}

// When the user is authenticated the state is changed to Authenticated.
class Authenticated extends AuthState {}

// This is the initial state of the bloc. When the user is not authenticated the state is changed to Unauthenticated.
class UnAuthenticated extends AuthState {}

class AuthCredStored extends AuthState {
  final String username;
  final String password;

  AuthCredStored(this.username, this.password);
}

// If any error occurs the state is changed to AuthError.
class AuthError extends AuthState {
  final String error;

  AuthError(this.error);
}
