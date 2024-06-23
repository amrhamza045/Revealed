import 'dart:convert';

import 'package:college_project/customWidgets/customAppBar.dart';
import 'package:flutter/material.dart';

class DownloadView extends StatefulWidget {
  const DownloadView({super.key, required this.response, required this.url});
  final String response;
  final String url;
  @override
  State<DownloadView> createState() => _DownloadViewState();
}

class _DownloadViewState extends State<DownloadView> {
  int currentPageIndex = 0;
  String prediction = '';
  double percentage = 0;
  @override
  void initState() {
    prediction = json.decode(widget.response)[0]['prediction'];
    percentage =
        double.parse(json.decode(widget.response)[1]['Confidence Score']);
    print(percentage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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

          appBar: const CustomAppBar(),
          // main body
          body: Center(
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(color: Colors.blue.shade200),
              child: Center(
                  child: Column(
                children: [
                  ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      child: Image(image: NetworkImage(widget.url))),
                  Text(
                    prediction,
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )
                ],
              )),
            ),
          ),
        ));
  }
}
