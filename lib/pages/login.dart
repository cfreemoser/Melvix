import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:netflix_gallery/bloc/auth_bloc.dart';
import 'package:netflix_gallery/helpers/constants.dart';
import 'package:netflix_gallery/widgets/adaptive_layout.dart';
import 'package:netflix_gallery/widgets/sign_in.dart';

class Login extends StatelessWidget {
  final textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      fontFamily: "NetflixSans");

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.of(context).pushReplacementNamed("/profiles");
        }
        if (state is AuthInitial) {
          BlocProvider.of<AuthBloc>(context).add(InitRequested());
        }
      },
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Container(
                width: 120,
                margin: const EdgeInsets.only(left: 20),
                child: SvgPicture.asset(
                  Constants.netflix_icon_full,
                )),
            actions: [
              Center(
                  child: Text("Hilfe",
                      style: textStyle, textAlign: TextAlign.center)),
              const SizedBox(width: 20),
              Center(child: Text("Datenschutz", style: textStyle)),
              const SizedBox(width: 20),
            ],
          ),
          body: Stack(
            children: [
              Positioned.fill(
                  child: Image.network(
                Constants.content_cover_image,
                fit: BoxFit.cover,
              )),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              Positioned(
                child: Center(
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is Loading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is UnAuthenticated) {
                        return _buildLoginView(context, null);
                      }
                      if (state is AuthError) {
                        return _buildLoginView(context, state.error);
                      }
                      return Container();
                    },
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildLoginView(BuildContext context, String? errorMessage) {
    return SignIn(
        errorMessage: errorMessage,
        onSignIn: (username, password) {
          BlocProvider.of<AuthBloc>(context).add(
            SignInRequested(
              username,
              password,
            ),
          );
        },
        onSignUp: (username, password) {
          BlocProvider.of<AuthBloc>(context).add(
            SignUpRequested(
              username,
              password,
            ),
          );
        });
  }
}
