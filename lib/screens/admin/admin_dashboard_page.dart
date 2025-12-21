import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  Future<int> _getCount(String collection) async {
    final snap =
    await FirebaseFirestore.instance.collection(collection).get();
    return snap.docs.length;
  }

  Future<int> _getUserRoleCount(String role) async {
    final snap = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: role)
        .get();
    return snap.docs.length;
  }

  Future<int> _getRecentCount(String collection) async {
    final sevenDaysAgo =
    Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 7)));

    final snap = await FirebaseFirestore.instance
        .collection(collection)
        .where('createdAt', isGreaterThan: sevenDaysAgo)
        .get();

    return snap.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 KPI GRID
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 3.3,
              children: [
                DashboardCard(
                  title: "Total Users",
                  icon: Icons.people,
                  future: _getCount("users"),
                  color: Colors.blue,
                ),
                DashboardCard(
                  title: "Tourists",
                  icon: Icons.person_pin_circle,
                  future: _getUserRoleCount("tourist"),
                  color: Colors.teal,
                ),
                DashboardCard(
                  title: "Artists",
                  icon: Icons.brush,
                  future: _getUserRoleCount("artist"),
                  color: Colors.deepPurple,
                ),
                DashboardCard(
                  title: "Shops",
                  icon: Icons.store,
                  future: _getCount("marketplace"),
                  color: Colors.green,
                ),
                DashboardCard(
                  title: "Itineraries",
                  icon: Icons.map,
                  future: _getCount("itineraries"),
                  color: Colors.orange,
                ),
                DashboardCard(
                  title: "Feedbacks",
                  icon: Icons.feedback,
                  future: _getCount("feedback_answers"),
                  color: Colors.pink,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 🔹 ACTIVITY SECTION
            const Text(
              "Recent Activity (Last 7 Days)",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            ActivityTile(
              title: "New Feedback Received",
              future: _getRecentCount("feedback_answers"),
              icon: Icons.rate_review,
            ),

            ActivityTile(
              title: "New Itineraries Created",
              future: _getRecentCount("itineraries"),
              icon: Icons.route,
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Future<int> future;
  final Color color;

  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
    required this.future,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.85),
            color.withOpacity(0.65),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<int>(
          future: future,
          builder: (context, snapshot) {
            final value = snapshot.hasData ? snapshot.data.toString() : "...";

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: 36, color: Colors.white),
                Text(
                  value!,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ActivityTile extends StatelessWidget {
  final String title;
  final Future<int> future;
  final IconData icon;

  const ActivityTile({
    super.key,
    required this.title,
    required this.future,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        trailing: FutureBuilder<int>(
          future: future,
          builder: (context, snapshot) {
            return Text(
              snapshot.hasData ? snapshot.data.toString() : "...",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            );
          },
        ),
      ),
    );
  }
}
