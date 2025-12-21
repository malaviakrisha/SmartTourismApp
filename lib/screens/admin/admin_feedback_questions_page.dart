import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../admin/admin_feedback_answers_page.dart';

class AdminFeedbackQuestionsPage extends StatelessWidget {
  const AdminFeedbackQuestionsPage({super.key});

  // 🔹 Dialog to add new feedback question
  void _showAddQuestionDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Feedback Question"),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: "Enter feedback question",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;

              await FirebaseFirestore.instance
                  .collection('feedback_questions')
                  .add({
                'question': controller.text.trim(),
                'isActive': true,
                'createdAt': FieldValue.serverTimestamp(),
              });

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Feedback question added")),
              );
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  // 🔹 Toggle active / inactive
  Future<void> _toggleStatus(String docId, bool current) async {
    await FirebaseFirestore.instance
        .collection('feedback_questions')
        .doc(docId)
        .update({'isActive': !current});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback Management"),
        centerTitle: true,
      ),

      // 🔹 ADD QUESTION BUTTON
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddQuestionDialog(context),
        child: const Icon(Icons.add),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('feedback_questions')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "No feedback questions added yet",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final isActive = doc['isActive'] as bool;

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

                  title: Text(
                    doc['question'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      children: [
                        Icon(
                          isActive ? Icons.check_circle : Icons.cancel,
                          size: 16,
                          color: isActive ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isActive ? "Active" : "Inactive",
                          style: TextStyle(
                            color: isActive ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 🔹 ACTIONS
                  trailing: IconButton(
                    icon: Icon(
                      isActive ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => _toggleStatus(doc.id, isActive),
                  ),

                  // 🔹 Navigate to answers page later
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AdminFeedbackAnswersPage(
                          questionId: doc.id,
                          questionText: doc['question'],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
