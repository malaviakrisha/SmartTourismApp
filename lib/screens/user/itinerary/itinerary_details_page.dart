import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItineraryDetailsPage extends StatelessWidget {
  final String itineraryId;
  final String itineraryTitle;

  const ItineraryDetailsPage({
    super.key,
    required this.itineraryId,
    required this.itineraryTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(itineraryTitle)),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('itinerary_items')
            .where('itineraryId', isEqualTo: itineraryId)
            .snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snap.data!.docs;
          int totalCost = 0;
          for (var item in docs) {
            totalCost += (item['price'] as int);
          }


          if (docs.isEmpty) {
            return const Center(child: Text("No shops added yet"));
          }

          /// 🔹 GROUP BY DAY → SLOT
          final Map<int, Map<String, List<QueryDocumentSnapshot>>> grouped = {};

          for (var doc in docs) {
            final day = doc['day'];
            final slot = doc['timeSlot'];

            grouped.putIfAbsent(day, () => {});
            grouped[day]!.putIfAbsent(slot, () => []);
            grouped[day]![slot]!.add(doc);
          }

          return ListView(
            padding: const EdgeInsets.all(12),
            children: grouped.entries.map((dayEntry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: Colors.blue.shade50,
                    child: Text(
                      "Total Estimated Cost: ₹$totalCost",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    "Day ${dayEntry.key}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  ...dayEntry.value.entries.map((slotEntry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          slotEntry.key.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),

                        ...slotEntry.value.map((item) {
                          return Card(
                            child: ListTile(
                              title: Text(item['shopName']),
                              subtitle: Text(
                                "${item['category']} • ₹${item['price']}",
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('itinerary_items')
                                      .doc(item.id)
                                      .delete();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Shop removed from itinerary")),
                                  );
                                },
                              ),
                            ),
                          );
                        }).toList(),

                        const SizedBox(height: 12),
                      ],
                    );
                  }).toList(),

                  const Divider(thickness: 1),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
