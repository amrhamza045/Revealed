// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:college_project/customWidgets/customTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key, this.myAuth});
  final FirebaseAuth? myAuth;

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController? _emailController;

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController!.dispose();
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
            const SizedBox(
              height: 100,
            ),

// ---------------------------------------------- Image ----------------------------------------------
            const Image(
              height: 150,
              image: AssetImage('assets/images/Logo.png'),
            ),

            const SizedBox(
              height: 100,
            ),

// ---------------------------------------------- Label ----------------------------------------------
            const Text(
              'Enter your email: ',
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 25,
            ),

// ---------------------------------------------- Email ----------------------------------------------
            CustomTextField(
                controller: _emailController,
                inputType: TextInputType.emailAddress,
                label: 'Email'),

            const SizedBox(
              height: 30,
            ),

// ---------------------------------------------- Submit ----------------------------------------------
            GestureDetector(
              onTap: () async {
                sendResetEmail(_emailController!.text.trim());
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
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// ---------------------------------------------- Reset Function ----------------------------------------------
  sendResetEmail(String email) async {
    try {
      await widget.myAuth!.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please check your email to reset your password."),
        ),
      );
      await Future.delayed(const Duration(seconds: 5), () {});
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: errorPrinter(e.code),
        ),
      );
    }
  }

// ---------------------------------------------- Error Handler ----------------------------------------------
  Text errorPrinter(String error) {
    if (error == 'invalid-email') {
      return const Text('Enter a valid email address');
    } else {
      return const Text('An error occured, please try again later');
    }
  }
}
