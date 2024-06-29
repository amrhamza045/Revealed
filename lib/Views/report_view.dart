import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_project/customWidgets/fadeNavigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ReportView extends StatefulWidget {
  ReportView({
    super.key,
    required this.myAuth,
    required this.imgFile,
  });

  final FirebaseAuth myAuth;
  final File imgFile;
  XFile? xImage;

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  File? response;
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
      ],
      actionsAlignment: MainAxisAlignment.spaceAround,
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      content: !loaded
          ? const CircularProgressIndicator.adaptive()
          : ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                url!,
                fit: BoxFit.cover,
              ),
            ),
      backgroundColor: const Color.fromARGB(255, 114, 147, 205),
    );
  }
  // uploadAndSend function and imagePicker function

  void uplaodAndSend() async {
    File response = await sendImage(widget.imgFile);
    widget.xImage = XFile(response.path);
    String url =
        await uploadImage(widget.myAuth.currentUser!.uid, widget.xImage!);

    setState(() {
      loaded = true;
      this.url = url;
      this.response = response;
    });
    await updateUserData();
  }

  Future<String> uploadImage(String path, XFile image) async {
    try {
      final ref = FirebaseStorage.instance
          .ref('files')
          .child('$path/reports/${image.name}');
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      print(e.code);
      return 'error happened';
    }
  }

  Future<File> sendImage(File image) async {
    final url = Uri.parse('https://a9df-197-59-143-216.ngrok-free.app/upload');
    final request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('file', image.path));
    final response = await request.send();
    final responseBytes = await response.stream.toBytes();

    var dir = await getApplicationDocumentsDirectory();
    File file = File('${dir.path}/heatmap.jpg');
    await file.writeAsBytes(responseBytes);
    return file;
  }

  Future updateUserData() async {
    int userUploads = await fetchUserData();

    await FirebaseFirestore.instance
        .collection('user_uploads')
        .doc('${widget.myAuth.currentUser!.displayName}$userUploads')
        .update({'hasReport': true, 'reportLink': url});
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
