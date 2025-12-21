import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ArtistPaymentPage extends StatefulWidget {
  const ArtistPaymentPage({super.key});

  @override
  State<ArtistPaymentPage> createState() => _ArtistPaymentPageState();
}

class _ArtistPaymentPageState extends State<ArtistPaymentPage> {
  bool _loading = false;

  Future<void> _payNow() async {
    setState(() => _loading = true);

    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      "plan": "premium",
      "isPaid": true,
      "paidAt": FieldValue.serverTimestamp(),
      "planDurationDays": 30,
    });

    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment successful. Plan activated")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upgrade Plan"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Premium Plan",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            const Text("• Add your shop"),
            const Text("• Accept bookings"),
            const Text("• Appear in tourist search"),
            const Text("• 30 days validity"),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Price: ₹299 / 30 days\n(Demo payment – no real money)",
                style: TextStyle(fontSize: 16),
              ),
            ),

            const Spacer(),

            _loading
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _payNow,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(14),
                ),
                child: const Text(
                  "Pay Now",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
