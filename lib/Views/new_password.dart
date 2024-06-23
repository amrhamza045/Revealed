import 'package:college_project/Views/log_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key, this.myAuth});
  final FirebaseAuth? myAuth;

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  String pass1 = "";
  String pass2 = "";
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController? _pass1Controller;
  TextEditingController? _pass2Controller;

  @override
  void initState() {
    _pass1Controller = TextEditingController();
    _pass2Controller = TextEditingController();
    _key = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    _pass1Controller!.dispose();
    _pass2Controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //--------------------------------------
    // image
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
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
              const Image(
                height: 150,
                image: AssetImage('assets/images/Logo.png'),
              ),

              const SizedBox(height: 100),
// ------------------------------------
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Create a new password ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),

              const SizedBox(
                height: 25,
              ),
//-------------------------------------
              //new password
              Form(
                key: _key,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: _pass1Controller,
                            validator: (value) {
                              return (value!.isEmpty)
                                  ? 'Password is Required'
                                  : null;
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter your new password  ',
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: _pass2Controller,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password is Required';
                              } else {
                                if (_pass1Controller!.text.trim() !=
                                    value.trim()) {
                                  return "Passwords don't match";
                                } else {
                                  return null;
                                }
                              }
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Confirm your new password  ',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  updateUserPassword(
                      _pass1Controller!.text, _pass2Controller!.text);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.blue.shade900,
                        borderRadius: BorderRadius.circular(18)),
                    child: const Center(
                        child: Text(
                      'confirm',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  updateUserPassword(String pass1, String pass2) async {
    if (checkValidity(pass1, pass2)) {
      try {
        await widget.myAuth!.currentUser!.updatePassword(pass1);
        await widget.myAuth!.signOut();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginView(),
            ));
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.code.replaceAll("-", " ")),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords don't match"),
        ),
      );
    }
  }

  bool checkValidity(String pass1, String pass2) {
    return pass1.trim() == pass2.trim() ? true : false;
  }
}
