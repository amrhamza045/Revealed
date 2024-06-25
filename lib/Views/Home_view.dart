import 'package:college_project/Views/feedback.dart';
import 'package:college_project/Views/history_view.dart';
import 'package:college_project/Views/profile_view.dart';
import 'package:college_project/Views/tmp.dart';
import 'package:college_project/Views/upload_view.dart';
import 'package:college_project/customWidgets/customAppBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, this.myAuth});
  final FirebaseAuth? myAuth;
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
// ---------------------------------------------- Pages ----------------------------------------------

  int currentPageIndex = 0;
  final pages = [
    UploadView(),
    TMPPage(),
    //HistoryView(),
    const FeedbackView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      },
      canPop: false,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Colors.blue.shade900,
            Colors.blue.shade400,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
        child: Scaffold(
          backgroundColor: Colors.transparent,
// ---------------------------------------------- Nav-Bar ----------------------------------------------
          bottomNavigationBar: SizedBox(
            height: 70,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              child: BottomNavigationBar(
                  items: [
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.home, color: Colors.white),
                      label: 'Home',
                      backgroundColor: Colors.blue.shade900,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.history, color: Colors.white),
                      label: 'History',
                      backgroundColor: Colors.blue.shade900,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.headset_mic_rounded,
                          color: Colors.white),
                      label: 'Support',
                      backgroundColor: Colors.blue.shade900,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.person, color: Colors.white),
                      label: 'Profile',
                      backgroundColor: Colors.blue.shade900,
                    ),
                  ],
                  currentIndex: currentPageIndex,
                  onTap: (value) {
                    setState(() {
                      currentPageIndex = value;
                    });
                  }),
            ),
          ),

// ---------------------------------------------- AppBar ----------------------------------------------
          appBar: const CustomAppBar(),

// ---------------------------------------------- Body ----------------------------------------------
          body: pages[currentPageIndex],
        ),
      ),
    );
  }
}
