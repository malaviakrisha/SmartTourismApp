import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SelectItinerarySheet extends StatelessWidget {
  final String shopId;
  final Map<String, dynamic> shopData;

  int selectedDay = 1;
  final TextEditingController dayController =
  TextEditingController(text: "1");
  String selectedSlot = 'morning';

  SelectItinerarySheet({
    required this.shopId,
    required this.shopData,
  });

  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('itineraries')
            .where('touristId', isEqualTo: uid)
            .snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final itineraries = snap.data!.docs;

          if (itineraries.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Text("Create an itinerary first"),
            );
          }

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Select Day",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButton<int>(
                  value: selectedDay,
                  items: List.generate(
                    7,
                        (index) => DropdownMenuItem(
                      value: index + 1,
                      child: Text("Day ${index + 1}"),
                    ),
                  ),
                  onChanged: (value) {
                    selectedDay = value!;
                  },
                ),
                const SizedBox(height: 12),
                const Text(
                  "Select Time Slot",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: selectedSlot,
                  items: const [
                    DropdownMenuItem(value: 'morning', child: Text("Morning")),
                    DropdownMenuItem(value: 'afternoon', child: Text("Afternoon")),
                    DropdownMenuItem(value: 'evening', child: Text("Evening")),
                  ],
                  onChanged: (value) {
                    selectedSlot = value!;
                  },
                ),
                const Divider(),
              ],
            ),
          );
          return ListView(
            children: itineraries.map((itinerary) {
              return ListTile(
                title: Text(itinerary['title']),
                  onTap: () async {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                            left: 16,
                            right: 16,
                            top: 16,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Add to Itinerary",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 12),

                              TextField(
                                controller: dayController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Day number",
                                ),
                              ),

                              const SizedBox(height: 12),

                              DropdownButtonFormField<String>(
                                value: selectedSlot,
                                items: const [
                                  DropdownMenuItem(value: 'morning', child: Text("Morning")),
                                  DropdownMenuItem(value: 'afternoon', child: Text("Afternoon")),
                                  DropdownMenuItem(value: 'evening', child: Text("Evening")),
                                ],
                                onChanged: (value) {
                                  selectedSlot = value!;
                                },
                                decoration: const InputDecoration(
                                  labelText: "Time Slot",
                                ),
                              ),

                              const SizedBox(height: 20),

                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  child: const Text("Add Shop"),
                                  onPressed: () async {
                                    final day = int.tryParse(dayController.text);

                                    if (day == null || day <= 0) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Enter a valid day number"),
                                        ),
                                      );
                                      return;
                                    }

                                    // CHECK DUPLICATE
                                    final existing = await FirebaseFirestore.instance
                                        .collection('itinerary_items')
                                        .where('itineraryId', isEqualTo: itinerary.id)
                                        .where('shopId', isEqualTo: shopId)
                                        .get();

                                    if (existing.docs.isNotEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content:
                                          Text("Shop already added to this itinerary"),
                                        ),
                                      );
                                      return;
                                    }

                                    await FirebaseFirestore.instance
                                        .collection('itinerary_items')
                                        .add({
                                      'itineraryId': itinerary.id,
                                      'shopId': shopId,
                                      'shopName': shopData['name'],
                                      'category': shopData['category'],
                                      'price': shopData['price'] ?? 0,
                                      'location': shopData['location'] ?? '',
                                      'latitude': (shopData['latitude'] ?? 0).toDouble(),
                                      'longitude':(shopData['longitude'] ?? 0).toDouble(),
                                      'day': day,
                                      'timeSlot': selectedSlot,
                                    });

                                    Navigator.pop(context); // close bottom sheet
                                    Navigator.pop(context); // close itinerary sheet

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Added to itinerary")),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 20),
                            ],
                          ),
                        );
                      },
                    );
                  },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
