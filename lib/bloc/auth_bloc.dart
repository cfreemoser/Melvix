import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:netflix_gallery/domain/credentials.dart';
import 'package:netflix_gallery/service/authentication_service.dart';
import 'package:netflix_gallery/service/secret_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationService _authenticationService;
  final SecretService _secretService;

  AuthBloc(this._authenticationService, this._secretService)
      : super(AuthInitial()) {
    // When User Presses the SignIn Button, we will send the SignInRequested Event to the AuthBloc to handle it and emit the Authenticated State if the user is authenticated
    on<SignInRequested>((event, emit) async {
      emit(Loading());
      try {
        await _authenticationService.signIn(
            email: event.email, password: event.password);

        if (event.storeCredentials) {
          await _secretService
              .storeCredentials(Credentials(event.email, event.password));
        }
        emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
    // When User Presses the SignUp Button, we will send the SignUpRequest Event to the AuthBloc to handle it and emit the Authenticated State if the user is authenticated
    on<SignUpRequested>((event, emit) async {
      emit(Loading());
      try {
        await _authenticationService.signUp(
            email: event.email, password: event.password);
        emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
    // When User Presses the SignOut Button, we will send the SignOutRequested Event to the AuthBloc to handle it and emit the UnAuthenticated State
    on<SignOutRequested>((event, emit) async {
      emit(Loading());
      await _authenticationService.signOut();
      emit(UnAuthenticated());
    });
    // When User Presses the SignOut Button, we will send the SignOutRequested Event to the AuthBloc to handle it and emit the UnAuthenticated State
    on<InitRequested>((event, emit) async {
      var isSignedIn = await _authenticationService.isSignedIn();
      if (isSignedIn) {
        emit(Authenticated());
      } else {
        emit(UnAuthenticated());
      }
      
      var cred = await _secretService.receiveCredentials();
      if (cred != null) {
        emit(AuthCredStored(cred.username, cred.password));
      }
    });
  }
}
