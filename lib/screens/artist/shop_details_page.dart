import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../user/itinerary/select_itinerary_sheet.dart';

class ShopDetailsPage extends StatelessWidget {
  final String shopId;

  const ShopDetailsPage({super.key, required this.shopId});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(title: const Text("Shop Details")),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('marketplace')
            .doc(shopId)
            .get(),
        builder: (context, shopSnap) {
          if (!shopSnap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final shop = shopSnap.data!;
          final shopData = shop.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(shopData['imageUrl'], height: 180),
                const SizedBox(height: 12),

                Text(
                  shopData['name'],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text("Category: ${shopData['category']}"),
                const SizedBox(height: 12),
                Text(shopData['description']),
                const SizedBox(height: 24),

                /// 🔐 ROLE CHECK
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .get(),
                  builder: (context, userSnap) {
                    if (!userSnap.hasData) return const SizedBox();

                    final userData =
                    userSnap.data!.data() as Map<String, dynamic>;

                    if (userData['role'] != 'tourist') {
                      return const SizedBox();
                    }

                    /// 📌 BOOKING STATUS CHECK
                    return FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('booking_requests')
                          .where('shopId', isEqualTo: shop.id)
                          .where('touristId', isEqualTo: user.uid)
                          .get(),
                      builder: (context, bookingSnap) {
                        if (!bookingSnap.hasData) {
                          return const SizedBox();
                        }

                        bool disableButton = false;
                        String buttonText = "Request Booking";

                        for (var doc in bookingSnap.data!.docs) {
                          final status = doc['status'];

                          if (status == 'pending') {
                            disableButton = true;
                            buttonText = "Request Pending";
                            break;
                          }

                          if (status == 'accepted') {
                            disableButton = true;
                            buttonText = "Booking Accepted";
                            break;
                          }
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            /// ✅ REQUEST BOOKING BUTTON
                            ElevatedButton(
                              onPressed: disableButton
                                  ? null
                                  : () async {
                                await FirebaseFirestore.instance
                                    .collection('booking_requests')
                                    .add({
                                  'shopId': shop.id,
                                  'shopName': shopData['name'],
                                  'touristId': user.uid,
                                  'touristName': userData['name'],
                                  'touristEmail': userData['email'],
                                  'artistId': shopData['ownerId'],
                                  'status': 'pending',
                                  'createdAt':
                                  FieldValue.serverTimestamp(),
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                    Text("Booking request sent"),
                                  ),
                                );
                              },
                              child: Text(buttonText),
                            ),

                            const SizedBox(height: 12),

                            /// 🗺️ ADD TO ITINERARY BUTTON
                            ElevatedButton.icon(
                              icon: const Icon(Icons.map),
                              label: const Text("Add to Itinerary"),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (_) => SelectItinerarySheet(
                                    shopId: shop.id,
                                    shopData: shopData,
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
