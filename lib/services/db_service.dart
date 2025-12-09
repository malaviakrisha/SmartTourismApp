// lib/services/db_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_tourism/models/shop_model.dart'; // <-- UPDATE THIS PATH TO MATCH YOUR PROJECT

class DBService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --------- CREATE SHOP ----------
  Future<String> createShop(Shop shop) async {
    final docRef = await _db.collection('shops').add(shop.toMap());
    return docRef.id; // returns the auto document ID
  }

  // --------- READ: All shops (for Tourist + Admin) ---------
  Stream<List<Shop>> getAllShops() {
    return _db
        .collection('shops')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Shop.fromDocument(doc)).toList());
  }

  // --------- READ: Shops by Artist ---------
  Stream<List<Shop>> getShopsByOwner(String ownerId) {
    return _db
        .collection('shops')
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Shop.fromDocument(doc)).toList());
  }

  // --------- DELETE SHOP (Admin OR Artist owner) ---------
  Future<void> deleteShop(String shopId) async {
    await _db.collection('shops').doc(shopId).delete();
  }

  // --------- UPDATE SHOP ----------
  Future<void> updateShop(String shopId, Map<String, dynamic> data) async {
    await _db.collection('shops').doc(shopId).update(data);
  }
}
