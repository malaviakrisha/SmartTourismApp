import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateItineraryPage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Itinerary")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Itinerary Name",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isEmpty) return;

                await FirebaseFirestore.instance
                    .collection('itineraries')
                    .add({
                  'touristId': uid,
                  'title': titleController.text,
                  'createdAt': FieldValue.serverTimestamp(),
                });

                Navigator.pop(context);
              },
              child: const Text("Create"),
            )
          ],
        ),
      ),
    );
  }
}
