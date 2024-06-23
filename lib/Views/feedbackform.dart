import 'package:flutter/material.dart';

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Stack(
        children: [
          Form(
            key: _formkey,
            child: SizedBox(
              height: 500,
              width: 500,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(27),
                    child: Image.asset(
                      "assets/images/thank_you_person.png",
                      fit: BoxFit.cover,
                      width: 390,
                      height: 230,
                    ),
                  ),
                  const Text(
                    " Thank You! ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    " For your feedback, ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w100),
                  ),
                  const Text(
                    "you helped us improve Revealed ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w100),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_formkey.currentState!.validate()) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text(
                          "Go back to home ",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 150, 201, 223),
    );
  }
}
