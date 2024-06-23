// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_project/Views/new_password.dart';
import 'package:college_project/Views/log_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends StatefulWidget {
  ProfileView({super.key});
  final FirebaseAuth? myAuth = FirebaseAuth.instance;
  final FirebaseFirestore cloud = FirebaseFirestore.instance;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String? userPhoneNumber;
  bool isLoading = true;
  XFile? image;
  String? imgPath;
  @override
  void initState() {
    fetchUserPhoneNumber();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              InkWell(
                onTap: () {
                  pickLocalFile();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(imgPath!),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.myAuth!.currentUser!.displayName!,
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    widget.myAuth!.currentUser!.email!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Phone Number',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    userPhoneNumber!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ListTile(
                leading: const Icon(
                  Icons.lock,
                  color: Colors.black87,
                ),
                title: const Text(
                  'Change Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewPassword(myAuth: widget.myAuth),
                    ),
                  );
                },
              ),
              const ListTile(
                leading: Icon(
                  Icons.info,
                  color: Colors.black87,
                ),
                title: Text(
                  'App Version 1.0.0',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  // logout
                  await widget.myAuth!.signOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginView(
                          myAuth: widget.myAuth,
                        ),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900,
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          );
  }

  Future<String?> getUserPhoneNumber(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        String? phoneNumber = data['phone number'];
        imgPath = data['pfpLink'];
        return phoneNumber;
      } else {
        return 'No User';
      }
    } catch (e) {
      return ' ';
    }
  }

  void fetchUserPhoneNumber() async {
    try {
      User? user = widget.myAuth!.currentUser;

      if (user != null) {
        String? phoneNumber = await getUserPhoneNumber(user.uid);

        if (mounted) {
          setState(() {
            userPhoneNumber = phoneNumber;
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> pickLocalFile() async {
    ImagePicker tmp = ImagePicker();
    image = await tmp.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        image = image;
      });
      uplaodAndSend();
    }
  }

  void uplaodAndSend() async {
    String url = await uploadImage(widget.myAuth!.currentUser!.uid, image!);
    updateUserData(url);
    setState(() {
      imgPath = url;
    });
  }

  Future<String> uploadImage(String path, XFile image) async {
    try {
      final ref = FirebaseStorage.instance.ref('files').child('$path/pfp');
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      print(e.code);
      return 'error happened';
    }
  }

  Future updateUserData(String url) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.myAuth!.currentUser!.uid)
        .update({'pfpLink': url});
  }
}
