import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_project/Views/report_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ResponseView extends StatefulWidget {
  const ResponseView(
      {super.key,
      required this.myAuth,
      required this.imgFile,
      required this.xImage});

  final FirebaseAuth myAuth;
  final File imgFile;
  final XFile xImage;

  @override
  State<ResponseView> createState() => _ResponseViewState();
}

class _ResponseViewState extends State<ResponseView> {
  String? response;
  String? url;
  String prediction = 'fake';
  double percentage = 0;
  bool loaded = false;
  @override
  void initState() {
    uplaodAndSend();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Home',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (context) {
                return ReportView(
                  myAuth: widget.myAuth,
                  imgFile: widget.imgFile,
                );
              },
            );
          },
          child: const Text(
            'Report',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        )
      ],
      actionsAlignment: MainAxisAlignment.spaceAround,
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      content: !loaded
          ? const CircularProgressIndicator.adaptive()
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    url!,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  prediction,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                LinearProgressIndicator(
                  value: (percentage),
                  color: const Color.fromARGB(255, 0, 75, 173),
                  backgroundColor: Colors.white,
                ),
                Text('${(percentage * 100).toStringAsFixed(5)} %'),
              ],
            ),
      backgroundColor: const Color.fromARGB(255, 114, 147, 205),
    );
  }

  void uplaodAndSend() async {
    String url =
        await uploadImage(widget.myAuth.currentUser!.uid, widget.xImage);
    String response = await sendImage(widget.imgFile);
    setState(() {
      loaded = true;
      this.url = url;
      this.response = response;
      print(response);
      prediction = json.decode(response)[0]['prediction'];
      percentage = double.parse(json.decode(response)[1]['Confidence Score']);
    });
    await updateUserData();
  }

  Future<String> uploadImage(String path, XFile image) async {
    try {
      final ref =
          FirebaseStorage.instance.ref('files').child('$path/${image.name}');
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      print(e.code);
      return 'error happened';
    }
  }

  Future<String> sendImage(File image) async {
    final url = Uri.parse('https://ada4-197-59-143-216.ngrok-free.app/');
    final request = http.MultipartRequest('POST', url);

    request.files.add(await http.MultipartFile.fromPath('file', image.path));
    final response = await request.send();
    final responseString = await response.stream.bytesToString();
    return responseString;
  }

  Future updateUserData() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.myAuth.currentUser!.uid)
        .update({'uploads': FieldValue.increment(1)});

    int userUploads = await fetchUserData();
    FirebaseFirestore.instance
        .collection('user_uploads')
        .doc('${widget.myAuth.currentUser!.displayName}$userUploads')
        .set({
      'ImagePath': url,
      'percentage': percentage,
      'prediction': prediction,
      'user': widget.myAuth.currentUser!.uid,
      'hasReport': false,
      'reportLink': " ",
    });
  }

  Future<int> fetchUserData() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.myAuth.currentUser!.uid)
        .get();

    Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
    int uploadNum = data['uploads'];
    return uploadNum;
  }
}
