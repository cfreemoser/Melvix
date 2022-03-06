import 'package:flutter/material.dart';
import 'package:netflix_gallery/widgets/adaptive_layout.dart';

class SignIn extends StatefulWidget {
  final Function(String username, String password) onSignIn;
  final Function(String username, String password) onSignUp;
  final String? errorMessage;

  const SignIn(
      {Key? key,
      required this.onSignIn,
      required this.onSignUp,
      this.errorMessage})
      : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool signUp = false;

  @override
  Widget build(BuildContext context) {
    var signInView = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email or Phone',
              filled: true,
              fillColor: Colors.grey,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              labelStyle: TextStyle(color: Colors.white),
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
          child: TextField(
            obscureText: true,
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              filled: true,
              fillColor: Colors.grey,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              labelStyle: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                var username = emailController.text;
                var password = passwordController.text;
                if (signUp) {
                  widget.onSignUp(username, password);
                } else {
                  widget.onSignIn(username, password);
                }
              },
              style: TextButton.styleFrom(
                  primary: Colors.white, backgroundColor: Colors.red),
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
            child: Row(
              children: [
                AdaptiveLayout.isDesktop(context)
                    ? Text(
                        signUp ? "Already an account?" : "Don't have an account?",
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
                  child: Text(
                    signUp ? "Sign in instead" : "Sign up",
                  ),
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
