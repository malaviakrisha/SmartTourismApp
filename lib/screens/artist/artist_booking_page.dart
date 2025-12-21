import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './artist_payment_page.dart';

class ArtistBookingsPage extends StatefulWidget {
  const ArtistBookingsPage({Key? key}) : super(key: key);

  @override
  State<ArtistBookingsPage> createState() => _ArtistBookingsPageState();
}

class _ArtistBookingsPageState extends State<ArtistBookingsPage> {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  bool isPlanActive(Timestamp? paidAt, int? durationDays) {
    if (paidAt == null || durationDays == null) return false;
    final expiryDate = paidAt.toDate().add(Duration(days: durationDays));
    return DateTime.now().isBefore(expiryDate);
  }
  Future<void> _checkPlan() async{
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    final paidAt = userDoc['paidAt'];
    final duration = userDoc['planDurationDays'];

    if (!isPlanActive(paidAt, duration)) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Plan Expired"),
          content: const Text("Please renew your plan to continue"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ArtistPaymentPage(),
                  ),
                );
              },
              child: const Text("Renew"),
            ),
          ],
        ),
      );
      return;
    }
  }

  @override
  @override
  void initState() {
    super.initState();
    _checkPlan();
  }
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
