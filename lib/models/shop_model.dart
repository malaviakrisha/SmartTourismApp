// lib/models/shop_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Shop {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String ownerId;
  final String category;
  final String location; // readable address
  final double latitude;
  final double longitude;
  final num price;
  final Timestamp createdAt;

  Shop({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.ownerId,
    required this.category,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.price,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'ownerId': ownerId,
      'category': category,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'price': price,
      'createdAt': createdAt,
    };
  }

  factory Shop.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Shop(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      ownerId: data['ownerId'] ?? '',
      category: data['category'] ?? '',
      location: data['location'] ?? '',
      latitude: (data['latitude'] ?? 0).toDouble(),
      longitude: (data['longitude'] ?? 0).toDouble(),
      price: data['price'] ?? 0,
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }
  // Optional: fromMap if you use Map<String, dynamic> elsewhere
  factory Shop.fromMap(String id, Map<String, dynamic> data) {
    return Shop(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      ownerId: data['ownerId'] ?? '',
      category: data['category'] ?? '',
      location: data['location'] ?? '',
      latitude: (data['latitude'] ?? 0).toDouble(),
      longitude: (data['longitude'] ?? 0).toDouble(),
      price: (data['price'] ?? 0) as num,
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }
}
