import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ArtistFeedbackPage extends StatefulWidget {
  const ArtistFeedbackPage({super.key});

  @override
  State<ArtistFeedbackPage> createState() => _ArtistFeedbackPageState();
}

class _ArtistFeedbackPageState extends State<ArtistFeedbackPage> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, int> _ratings = {};
  bool _submitting = false;

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submitFeedback(List<QueryDocumentSnapshot> questions) async {
    final user = FirebaseAuth.instance.currentUser!;


    setState(() => _submitting = true);

    try {
      final batch = FirebaseFirestore.instance.batch();

      for (var q in questions) {
        final answer = _controllers[q.id]?.text.trim();
        final rating = _ratings[q.id];

        if (answer == null || answer.isEmpty || rating == null) continue;

        final ref =
        FirebaseFirestore.instance.collection('feedback_answers').doc();

        batch.set(ref, {
          "questionId": q.id,
          "userId": user.uid,
          "userName": user.displayName ?? "User",
          "userRole": "artist",
          "answer": answer,
          "rating": rating,
          "createdAt": FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Feedback submitted successfully")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('feedback_questions')
            .where('isActive', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final questions = snapshot.data!.docs;

          if (questions.isEmpty) {
            return const Center(
              child: Text(
                "No feedback available at the moment",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          for (var q in questions) {
            _controllers.putIfAbsent(
                q.id, () => TextEditingController());
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ...questions.map((q) {
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🔹 QUESTION
                        Text(
                          q['question'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // 🔹 STAR RATING
                        Row(
                          children: List.generate(5, (i) {
                            final selected = (_ratings[q.id] ?? 0) > i;
                            return IconButton(
                              icon: Icon(
                                selected
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                              ),
                              onPressed: () {
                                setState(() {
                                  _ratings[q.id] = i + 1;
                                });
                              },
                            );
                          }),
                        ),

                        // 🔹 ANSWER FIELD
                        TextField(
                          controller: _controllers[q.id],
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: "Write your feedback",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),

              const SizedBox(height: 20),

              _submitting
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: () => _submitFeedback(questions),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(14),
                ),
                child: const Text(
                  "Submit Feedback",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
