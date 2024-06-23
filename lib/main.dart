import 'package:college_project/Views/log_in_page.dart';
import 'package:college_project/Views/Home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});
  final FirebaseAuth? _mAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // this is a tests
      debugShowCheckedModeBanner: false,
      home: (_mAuth!.currentUser == null ||
              _mAuth.currentUser!.emailVerified == false)
          ? LoginView(myAuth: _mAuth)
          : HomeView(myAuth: _mAuth),
    );
  }
}
