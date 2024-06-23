import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_project/Models/upload_History_Data.dart';
import 'package:college_project/customWidgets/History_Card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HistoryView extends StatefulWidget {
  HistoryView({super.key});
  final FirebaseAuth myAuth = FirebaseAuth.instance;
  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  bool loaded = false;
  List<HistoryData> userHistory = [];

  @override
  void initState() {
    getHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !loaded
        ? const Center(child: CircularProgressIndicator.adaptive())
        : ListView.builder(
            itemCount: userHistory.length,
            itemBuilder: (context, index) {
              return HistoryCard(
                imgPath: userHistory[index].imagePath,
                title: userHistory[index].decision,
                sub: userHistory[index].description,
              );
            },
          );
  }

  Future getHistory() async {
    List<HistoryData> historyDataList = [];
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('user_uploads').get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        HistoryData historyData = HistoryData(
          decision: data['prediction'],
          imagePath: data['ImagePath'],
          description: '${data['percentage']}% confidence',
        );
        if (data['user'] == widget.myAuth.currentUser!.uid) {
          historyDataList.add(historyData);
        }
      }
    } catch (e) {
      print("Error fetching user uploads: $e");
    }

    setState(() {
      userHistory = historyDataList;
      loaded = true;
      if (historyDataList.isEmpty) {
        userHistory.add(HistoryData(
          decision: 'No uploads yet',
          imagePath: 'https://via.placeholder.com/150',
          description: 'Upload an image to get started',
        ));
      }
    });
  }
}
