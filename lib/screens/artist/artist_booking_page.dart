import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ArtistBookingsPage extends StatelessWidget {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Booking Requests")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('booking_requests')
            .where('artistId', isEqualTo: uid)
            .snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snap.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final booking = docs[index];

              return Card(
                child: ListTile(
                  title: Text(booking['shopName']),
                  subtitle: Text("Status: ${booking['status']}"),
                  trailing: booking['status'] == 'pending'
                      ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check,
                            color: Colors.green),
                        onPressed: () {
                          booking.reference
                              .update({'status': 'accepted'});
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close,
                            color: Colors.red),
                        onPressed: () {
                          booking.reference
                              .update({'status': 'rejected'});
                        },
                      ),
                    ],
                  )
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
