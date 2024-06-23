// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_project/Views/feedbackform.dart';
import 'package:college_project/customWidgets/customTextField.dart';
import 'package:college_project/customWidgets/commentTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';

class FeedbackView extends StatefulWidget {
  const FeedbackView({super.key});

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  GlobalKey<FormState>? _key;
  TextEditingController? emailController;
  TextEditingController? commentController;
  int selectedEmoji = -1;

  @override
  void initState() {
    emailController = TextEditingController();
    commentController = TextEditingController();
    _key = GlobalKey<FormState>();

    super.initState();
  }

  @override
  void dispose() {
    emailController!.dispose();
    commentController!.dispose();
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
            const SizedBox(height: 60),

            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
// ---------------------------------------------- Image & Logo ----------------------------------------------
                Image(
                  height: 50,
                  image: AssetImage('assets/images/Logo.png'),
                ),
                Text(
                  '  Revealed ',
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
              ],
            ),

            const SizedBox(height: 40),

// ---------------------------------------------- Form ----------------------------------------------
            Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
// ---------------------------------------------- Label ----------------------------------------------
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'E-mail Address',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

// ---------------------------------------------- Email ----------------------------------------------
                  CustomTextField(
                      controller: emailController,
                      inputType: TextInputType.emailAddress,
                      label: "E-mail Address"),

                  const SizedBox(height: 40),

// ---------------------------------------------- Label ----------------------------------------------
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'React(option)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

// ---------------------------------------------- Emoji ----------------------------------------------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white, // Set background color
                      ),
                      child: EmojiFeedback(
                        onChanged: (index) {
                          setState(() {
                            selectedEmoji = index;
                          });
                        },
                      ),
                    ),
                  ),

// ---------------------------------------------- Label ----------------------------------------------
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Comment',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

// ---------------------------------------------- Comment ----------------------------------------------
                  CommentTextField(
                    controller: commentController,
                    inputType: TextInputType.multiline,
                    label: "Comment",
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 15,
            ),

// ---------------------------------------------- Button ----------------------------------------------

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ElevatedButton(
                onPressed: () async {
                  await sendFeedback();
                  showDialog(
                    builder: (BuildContext context) {
                      return const FeedbackForm();
                    },
                    context: context,
                  );
                },
                style: ButtonStyle(
                  elevation: const MaterialStatePropertyAll(0),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.blue.shade900),
                ),
                child: const Text(
                  'send',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  Future sendFeedback() async {
    if (_key!.currentState!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance.collection('feedback').doc(user!.uid).set({
        'email': emailController!.text,
        'comment': commentController!.text,
        'Reaction': selectedEmoji,
      });

      // Clear the text fields
      emailController!.clear();
      commentController!.clear();

      // Reset the emoji
      setState(() {
        selectedEmoji = 0;
      });
    }
  }
}
