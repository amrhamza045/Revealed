// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_project/Views/log_in_page.dart';
import 'package:college_project/customWidgets/customTextField.dart';
import 'package:college_project/customWidgets/passwordTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key, this.myAuth});
  final FirebaseAuth? myAuth;
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController? _emailController;
  TextEditingController? _passController;
  TextEditingController? _usernameController;
  TextEditingController? _phoneController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passController = TextEditingController();
    _usernameController = TextEditingController();
    _phoneController = TextEditingController();
    _key = GlobalKey<FormState>();

    super.initState();
  }

  @override
  void dispose() {
    _emailController!.dispose();
    _passController!.dispose();
    _phoneController!.dispose();
    _usernameController!.dispose();
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

            const SizedBox(height: 50),
// ---------------------------------------------- Label ----------------------------------------------
            const Text(
              'Just one step & you can find the truth',
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
// ---------------------------------------------- Form ----------------------------------------------
            Form(
              key: _key,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
// ---------------------------------------------- Email ----------------------------------------------
                    CustomTextField(
                        controller: _emailController,
                        inputType: TextInputType.emailAddress,
                        label: 'Email'),

                    const SizedBox(
                      height: 25,
                    ),
// ---------------------------------------------- Phone Number ----------------------------------------------
                    CustomTextField(
                        controller: _phoneController,
                        inputType: TextInputType.phone,
                        label: 'Phone Number'),

                    const SizedBox(
                      height: 25,
                    ),
// ---------------------------------------------- Username ----------------------------------------------
                    CustomTextField(
                        controller: _usernameController,
                        inputType: TextInputType.name,
                        label: 'Username'),

                    const SizedBox(
                      height: 25,
                    ),
// ---------------------------------------------- Password ----------------------------------------------
                    PasswordTextField(
                      controller: _passController,
                      inputType: TextInputType.visiblePassword,
                      label: 'Password',
                    )
                  ]),
            ),

            const SizedBox(
              height: 30,
            ),
// ---------------------------------------------- Sign-up ----------------------------------------------

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: GestureDetector(
                onTap: () {
                  if (_key.currentState!.validate()) {
                    register(_emailController!.text, _passController!.text);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Center(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

// ---------------------------------------------- Login ----------------------------------------------

            const SizedBox(
              height: 25,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Have an account? ',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return (LoginView(
                            myAuth: widget.myAuth,
                          ));
                        },
                      ),
                    );
                  },
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  moveToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginView(
          myAuth: widget.myAuth,
        ),
      ),
    );
  }

// ---------------------------------------------- Register Function ----------------------------------------------
  register(String email, String password) async {
    try {
      await widget.myAuth!
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        user.updateDisplayName(_usernameController!.text);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please Check your mail for the verification email"),
        ),
      );
      await saveUserData(user!);
      moveToLogin();
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: errorPrinter(e.code),
        ),
      );
    } on FirebaseException catch (e) {
      print(e.code);
    }
  }

// ---------------------------------------------- Data Saver ----------------------------------------------
  Future<void> saveUserData(User user) async {
    FirebaseFirestore.instance.collection('users').doc(user.uid).set(
      {
        'email': _emailController!.text,
        'name': _usernameController!.text,
        'phone number': _phoneController!.text,
        'pfpLink':
            'https://firebasestorage.googleapis.com/v0/b/graduationproject-fd501.appspot.com/o/user.jpg?alt=media&token=f4af8b21-7cff-498e-bcfb-f39ba64110d0'
      },
    );
  }

// ---------------------------------------------- Error Handler ----------------------------------------------
  Text errorPrinter(String error) {
    if (error == 'invalid-email') {
      return const Text('Enter a valid email address');
    } else if (error == 'weak-password') {
      return const Text('Password is too weak');
    } else if (error == 'email-already-in-use') {
      return const Text('Email already used');
    } else {
      return const Text('An error occured, please try again later');
    }
  }
}
