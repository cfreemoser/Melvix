import 'package:flutter/material.dart';
import 'package:netflix_gallery/helpers/constants.dart';
import 'package:netflix_gallery/widgets/adaptive_layout.dart';

class SignIn extends StatefulWidget {
  final Function(String username, String password, bool storeCredentials)
      onSignIn;
  final Function(String username, String password) onSignUp;
  final String? errorMessage;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool injectedCred;

  const SignIn({
    Key? key,
    required this.onSignIn,
    required this.onSignUp,
    required this.usernameController,
    required this.passwordController,
    this.errorMessage,
    this.injectedCred = false,
  }) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool signUp = false;
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    var signInView = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: TextFormField(
            style: const TextStyle(color: Colors.white),
            controller: widget.usernameController,
            decoration: InputDecoration(
              labelText: 'Email or Phone',
              filled: true,
              fillColor: Colors.grey.shade800,
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              labelStyle: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        widget.errorMessage == null
            ? const SizedBox()
            : Text(
                widget.errorMessage!,
                style: const TextStyle(color: Colors.amber),
              ),
        Container(
          padding: const EdgeInsets.all(16),
          child: TextFormField(
            style: const TextStyle(color: Colors.white),
            obscureText: true,
            controller: widget.passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              filled: true,
              fillColor: Colors.grey.shade800,
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              labelStyle: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                var username = widget.usernameController.text;
                var password = widget.passwordController.text;
                if (signUp) {
                  widget.onSignUp(username, password);
                } else {
                  widget.onSignIn(username, password, rememberMe);
                }
              },
              style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Constants.netflix_red),
              child: Text(
                signUp ? "Sign up" : "Sign in",
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  children: [
                    AdaptiveLayout.isDesktop(context)
                        ? Text(
                            signUp
                                ? "Already an account?"
                                : "Don't have an account?",
                            style: const TextStyle(color: Colors.grey),
                          )
                        : const SizedBox(),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          signUp = !signUp;
                        });
                      },
                      style: TextButton.styleFrom(primary: Colors.white),
                      child: Row(
                        children: [
                          Text(
                            signUp ? "Sign in instead" : "Sign up",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                signUp
                    ? Container()
                    : Row(
                        children: [
                          Checkbox(
                            checkColor: Colors.white,
                            fillColor:
                                MaterialStateProperty.resolveWith(getColor),
                            value: rememberMe || widget.injectedCred,
                            onChanged: (v) => setState(() {
                              if (v != null) {
                                rememberMe = v;
                              }
                            }),
                          ),
                          TextButton(
                            onPressed: () => setState(() {
                              rememberMe = !rememberMe;
                            }),
                            child: Text("Remember me",
                                style: TextStyle(color: Constants.netflix_red)),
                          )
                        ],
                      ),
              ],
            ),
          ),
        )
      ],
    );

    return AdaptiveLayout(
      mobile: signInView,
      desktop: Container(
        width: 400,
        height: 600,
        color: Colors.black.withOpacity(0.8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 64, left: 64),
              child: Text(signUp ? 'Sign Up' : 'Sign In',
                  style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
            Expanded(
              child: Center(
                child: SizedBox(
                  width: 300,
                  child: signInView,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
