import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShopDetailsPage extends StatelessWidget {
  final String shopId;

  const ShopDetailsPage({Key? key, required this.shopId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("marketplace")
            .doc(shopId)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  data['imageUrl'],
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data['name'],
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),

                      const SizedBox(height: 8),

                      Text("Category: ${data['category']}"),
                      Text("Location: ${data['location']}"),

                      const SizedBox(height: 8),

                      Text("Price: ₹${data['price']}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),

                      const SizedBox(height: 12),

                      const Text("Description:",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(data['description']),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
