import 'dart:io';
import 'package:college_project/Views/responce_view.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadView extends StatefulWidget {
  UploadView({super.key});
  final FirebaseAuth myAuth = FirebaseAuth.instance;
  @override
  State<UploadView> createState() => _UploadViewState();
}

class _UploadViewState extends State<UploadView> {
  String fileName = 'Click here to choose a file';
  XFile? image;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 300,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.blue.shade200,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
// ---------------------------------------------- Upload box ----------------------------------------------
            InkWell(
              onTap: () async {
                await pickLocalFile();
              },
              child: DottedBorder(
                borderPadding: const EdgeInsets.all(8),
                color: Colors.white,
                strokeWidth: 4,
                dashPattern: const [
                  10,
                  10,
                ],
                child: SizedBox(
                  height: 150,
                  width: 280,
                  child: Center(
                    child: Text(
                      fileName,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),

// ---------------------------------------------- Url TextField ----------------------------------------------
            Container(
              margin: const EdgeInsets.all(8),
              width: 380,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Enter URL',
                  alignLabelWithHint: false,
                ),
              ),
            ),

// ---------------------------------------------- Upload Button ----------------------------------------------
            ElevatedButton(
              onPressed: () async {
                if (image == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          "Please choose an image to upload or enter a URL."),
                    ),
                  );
                  return;
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return ResponseView(
                        myAuth: widget.myAuth,
                        imgFile: File(image!.path),
                        xImage: image!,
                      );
                    },
                  );
                }
              },
              style: ButtonStyle(
                minimumSize: const MaterialStatePropertyAll(
                  Size(250, 40),
                ),
                elevation: const MaterialStatePropertyAll(0),
                backgroundColor: MaterialStatePropertyAll(
                  Colors.blue.shade900,
                ),
              ),
              child: const Text(
                'Detect',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// ---------------------------------------------- Pick Function ----------------------------------------------
  Future<void> pickLocalFile() async {
    ImagePicker tmp = ImagePicker();
    image = await tmp.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(
        () {
          fileName = image!.name;
        },
      );
    }
  }
}
