import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminBookingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Bookings")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('booking_requests')
            .snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snap.data!.docs.map((doc) {
              return ListTile(
                title: Text(doc['shopName']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tourist: ${doc['touristName']}"),
                    Text("Email: ${doc['touristEmail']}"),
                    Text("Status: ${doc['status']}"),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
