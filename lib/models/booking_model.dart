import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String shopId;
  final String shopName;

  final String touristId;
  final String touristName;
  final String touristEmail;

  final String artistId;
  final String status;
  final Timestamp createdAt;

  Booking({
    required this.id,
    required this.shopId,
    required this.shopName,
    required this.touristId,
    required this.touristName,
    required this.touristEmail,
    required this.artistId,
    required this.status,
    required this.createdAt,
  });

  factory Booking.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Booking(
      id: doc.id,
      shopId: data['shopId'],
      shopName: data['shopName'],
      touristId: data['touristId'],
      touristName: data['touristName'],
      touristEmail: data['touristEmail'],
      artistId: data['artistId'],
      status: data['status'],
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'shopId': shopId,
      'shopName': shopName,
      'touristId': touristId,
      'touristName': touristName,
      'touristEmail': touristEmail,
      'artistId': artistId,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
