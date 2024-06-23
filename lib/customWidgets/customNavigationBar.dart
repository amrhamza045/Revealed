import 'package:flutter/material.dart';

class CustomNavBar extends StatefulWidget {
  const CustomNavBar({super.key});

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  @override
  Widget build(BuildContext context) {
    int currentPageIndex = 0;
    return Container(
      height: 70,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        child: NavigationBar(
          backgroundColor: Colors.blue.shade900,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home, color: Colors.white),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.history, color: Colors.white),
              label: 'History',
            ),
            NavigationDestination(
              icon: Icon(Icons.headset_mic_rounded, color: Colors.white),
              label: 'Support',
            ),
            NavigationDestination(
              icon: Icon(Icons.person, color: Colors.white),
              label: 'Profile',
            ),
          ],
          indicatorColor: Colors.blueGrey,
          selectedIndex: currentPageIndex,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          onDestinationSelected: (value) {
            setState(() {
              currentPageIndex = value;
            });
          },
        ),
      ),
    );
  }
}
