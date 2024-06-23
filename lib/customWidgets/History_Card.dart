import 'package:flutter/material.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard({
    super.key,
    required this.imgPath,
    required this.title,
    required this.sub,
  });
  final String imgPath, title, sub;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      width: 50,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.blue.shade200,
        border: Border.all(color: Colors.transparent),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 2),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image(
                image: NetworkImage(imgPath),
                fit: BoxFit.fill,
                width: 120,
                height: 150,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 5,
              ),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(sub, overflow: TextOverflow.ellipsis),
            ],
          )
        ],
      ),
    );
  }
}
