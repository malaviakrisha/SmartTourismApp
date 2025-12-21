import 'package:cloud_firestore/cloud_firestore.dart';

bool isPlanActive(Timestamp? paidAt, int durationDays) {
  if (paidAt == null) return false;

  final paidDate = paidAt.toDate();
  final expiryDate = paidDate.add(Duration(days: durationDays));

  return DateTime.now().isBefore(expiryDate);
}
