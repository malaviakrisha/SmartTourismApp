import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TouristBookingsPage extends StatelessWidget {
  TouristBookingsPage({super.key});

  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Bookings")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('booking_requests')
            .where('touristId', isEqualTo: uid)
            .snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snap.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No bookings yet"));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final booking = docs[index];
              final status = booking['status'];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// SHOP INFO
                      Text(
                        booking['shopName'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text("Status: $status"),

                      /// ONLY IF ACCEPTED → SHOW ARTIST DETAILS
                      if (status == 'accepted') ...[
                        const Divider(height: 24),

                        const Text(
                          "Artist Details",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(booking['artistId'])
                              .get(),
                          builder: (context, artistSnap) {
                            if (!artistSnap.hasData) {
                              return const Text("Loading artist details...");
                            }

                            final artistData =
                            artistSnap.data!.data() as Map<String, dynamic>;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Name: ${artistData['name']}"),
                                Text("Email: ${artistData['email']}"),
                                if (artistData['phone'] != null)
                                  Text("Phone: ${artistData['phone']}"),
                              ],
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
