// ignore_for_file: use_build_context_synchronously

import 'package:college_project/Views/Home_view.dart';
import 'package:college_project/Views/forget_password.dart';
import 'package:college_project/Views/register.dart';
import 'package:college_project/customWidgets/customTextField.dart';
import 'package:college_project/customWidgets/fadeNavigation.dart';
import 'package:college_project/customWidgets/passwordTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key, this.myAuth});
  final FirebaseAuth? myAuth;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  GlobalKey<FormState>? _key;
  TextEditingController? _emailController;
  TextEditingController? _passController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passController = TextEditingController();
    _key = GlobalKey<FormState>();

    super.initState();
  }

  @override
  void dispose() {
    _emailController!.dispose();
    _passController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade900,
            Colors.blue.shade400,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ListView(
          children: [
            const SizedBox(height: 100),
// ---------------------------------------------- Image ----------------------------------------------
            const Image(
              height: 150,
              image: AssetImage('assets/images/Logo.png'),
            ),

            const SizedBox(height: 100),
// ---------------------------------------------- Form ----------------------------------------------
            Form(
              key: _key,
              child: Column(
                children: [
// ---------------------------------------------- Email ----------------------------------------------
                  CustomTextField(
                      controller: _emailController,
                      inputType: TextInputType.emailAddress,
                      label: 'Email'),
                  const SizedBox(height: 30),

// ---------------------------------------------- Password ----------------------------------------------
                  PasswordTextField(
                      controller: _passController,
                      inputType: TextInputType.visiblePassword,
                      label: 'Password'),
                ],
              ),
            ),

// ---------------------------------------------- Login ----------------------------------------------
            const SizedBox(
              height: 30,
            ),

            GestureDetector(
              onTap: () {
                if (_key!.currentState!.validate()) {
                  login(_emailController!.text, _passController!.text);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Center(
                    child: Text(
                      'Log in',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

// ---------------------------------------------- Password Reset ----------------------------------------------
            const SizedBox(
              height: 30,
            ),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return (ForgetPassword(
                        myAuth: widget.myAuth,
                      ));
                    },
                  ),
                );
              },
              child: const Text(
                'Forgotton Password?',
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),

// ---------------------------------------------- Sign-up ----------------------------------------------
            const SizedBox(
              height: 100,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Do not have an account? ',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(FadeRoute(
                        page: RegisterView(
                      myAuth: widget.myAuth,
                    )));
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) {
                    //       return (RegisterView(
                    //         myAuth: widget.myAuth,
                    //       ));
                    //     },
                    //   ),
                    // );
                  },
                  child: const Text(
                    'Sign up',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

// ---------------------------------------------- Login Function ----------------------------------------------
  login(String email, String pass) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass);
      User? user = userCredential.user;

      if (user != null) {
        await user.reload();
        if (!user.emailVerified) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Please verify your email"),
            ),
          );
          return;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Logged in successfully"),
            ),
          );
          moveToHome();
        }
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: errorPrinter(e.code),
        ),
      );
    }
  }

// ---------------------------------------------- Move to Homepage ----------------------------------------------
  moveToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeView(
          myAuth: widget.myAuth,
        ),
      ),
    );
  }

// ---------------------------------------------- Error Handler ----------------------------------------------
  Text errorPrinter(String error) {
    if (error == 'invalid-email') {
      return const Text('Enter a valid email address');
    } else if (error == 'wrong-password') {
      return const Text('Password is incorrect');
    } else if (error == 'invalid-credential') {
      return const Text("Account Doesn't exits");
    } else if (error == 'user-not-found') {
      return const Text("Account doesn't exist");
    } else {
      return const Text('An error occured, please try again later');
    }
  }
}
