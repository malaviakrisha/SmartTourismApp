import 'package:cloud_firestore/cloud_firestore.dart';

class Itinerary {
  final String id;
  final String touristId;
  final String title;
  final Timestamp createdAt;

  Itinerary({
    required this.id,
    required this.touristId,
    required this.title,
    required this.createdAt,
  });

  factory Itinerary.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Itinerary(
      id: doc.id,
      touristId: data['touristId'],
      title: data['title'],
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'touristId': touristId,
      'title': title,
      'createdAt': createdAt,
    };
  }
}
