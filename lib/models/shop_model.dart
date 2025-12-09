// lib/models/shop_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Shop {
  final String id;
  final String name;
  final String description;
  final String imageUrl; // primary image (Cloudinary secure_url)
  final String ownerId; // artist uid
  final String category;
  final String location; // freeform: city / coords string
  final num price; // optional price for items or avg price
  final Timestamp createdAt;

  Shop({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.ownerId,
    required this.category,
    required this.location,
    required this.price,
    required this.createdAt,
  });

  // For saving to Firestore (exclude id because id is doc id)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'ownerId': ownerId,
      'category': category,
      'location': location,
      'price': price,
      'createdAt': createdAt,
    };
  }

  // Initialize using a Firestore document snapshot
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
      price: (data['price'] ?? 0) as num,
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
      price: (data['price'] ?? 0) as num,
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }
}
