import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import './base_map_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItineraryMapPage extends StatelessWidget {
  final String itineraryId;

  const ItineraryMapPage({
    super.key,
    required this.itineraryId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Itinerary Map")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('itinerary_items')
            .where('itineraryId', isEqualTo: itineraryId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No locations to show"));
          }

          final markers = docs.map((doc) {
            return Marker(
              point: LatLng(doc['latitude'], doc['longitude']),
              width: 40,
              height: 40,
              child: const Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 40,
              ),
            );
          }).toList();

          final first = docs.first;

          return BaseMapWidget(
            center: LatLng(first['latitude'], first['longitude']),
            markers: markers,
          );
        },
      ),
    );
  }
}
