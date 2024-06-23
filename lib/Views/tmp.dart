import 'package:flutter/material.dart';

class TMPPage extends StatefulWidget {
  const TMPPage({super.key});

  @override
  State<TMPPage> createState() => _TMPPageState();
}

class _TMPPageState extends State<TMPPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: [
        ElevatedButton(
          onPressed: () {},
          child: const Text('data'),
          style: const ButtonStyle(
            maximumSize: MaterialStatePropertyAll(
              Size(100, 100),
            ),
            fixedSize: MaterialStatePropertyAll(Size.fromHeight(20)),
          ),
        )
      ],
    );
  }
}
