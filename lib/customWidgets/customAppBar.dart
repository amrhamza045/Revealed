import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue.shade900,
      elevation: 0,
    
      title: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
            Colors.yellow.shade800,
          ),
          minimumSize: const MaterialStatePropertyAll(
            Size(200, 40),
          ),
        ),
        child: const Text(
          'Gold Pack',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      centerTitle: true,
    );
  }
}
