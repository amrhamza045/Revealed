import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_project/customWidgets/History_Card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TMPPage extends StatefulWidget {
  const TMPPage({super.key});

  @override
  State<TMPPage> createState() => _TMPPageState();
}

class _TMPPageState extends State<TMPPage> {
  List<DocumentSnapshot> uploads = [];
  String filter = 'all';

  @override
  void initState() {
    super.initState();
    fetchUploads();
  }

  Future<void> fetchUploads() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('user_uploads').get();
    setState(() {
      uploads = snapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<DocumentSnapshot> filteredUploads = uploads.where((upload) {
      if (filter == 'all' &&
          upload['user'] == FirebaseAuth.instance.currentUser!.uid) {
        return true;
      } else {
        return (((upload['prediction'] as String).trim() == filter) &&
            upload['user'] == FirebaseAuth.instance.currentUser!.uid);
      }
    }).toList();

    return Column(
      children: [
        Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              filterButton('All', 'all'),
              filterButton('Real', 'Real'),
              filterButton('Filtered', 'Filtered'),
              filterButton('Generated', 'Fully Generated'),
            ],
          ),
        ),
        Expanded(
            child: filteredUploads.isEmpty
                ? ListView(children: const [
                    HistoryCard(
                      imgPath: 'https://via.placeholder.com/150',
                      title: 'No uploads yet',
                      sub: 'Upload an image to get started',
                    ),
                  ])
                : ListView.builder(
                    itemCount: filteredUploads.length,
                    itemBuilder: (context, index) {
                      return HistoryCard(
                        imgPath: filteredUploads[index]['ImagePath'],
                        title: filteredUploads[index]['prediction'],
                        sub:
                            '${filteredUploads[index]['percentage']}% confidence',
                      );
                    },
                  ))
      ],
    );
  }

  Widget filterButton(String text, String category) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            filter = category;
          });
        },
        child: Text(text),
      ),
    );
  }
}
