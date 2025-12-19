import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './create_itinerary_page.dart';
import './itinerary_details_page.dart ';

class TouristItineraryPage extends StatelessWidget {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Itineraries"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreateItineraryPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('itineraries')
            .where('touristId', isEqualTo: uid)
            .snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snap.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No itineraries yet"));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final itinerary = docs[index];
              return ListTile(
                title: Text(itinerary['title']),
                subtitle: const Text("Tap to view details"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ItineraryDetailsPage(
                        itineraryId: itinerary.id,
                        itineraryTitle: itinerary['title'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
