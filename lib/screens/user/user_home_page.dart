import 'package:flutter/material.dart';
import '../../widgets/top_navbar.dart';
import '../../widgets/bottom_nav.dart';
import '../../services/auth_service.dart';
import '/auth.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int _selectedIndex = 0;
  String role = "tourist"; // fallback until Firestore role is fetched

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  // Fetch user role from Firestore
  void _loadRole() async {
    final fetchedRole = await AuthServiceHelper().getUserRole();
    if (fetchedRole != null) {
      setState(() => role = fetchedRole);
    }
  }

  // Handle bottom nav icon taps
  void _onTabSelected(int index) {
    setState(() => _selectedIndex = index);
    // Later you’ll add navigation logic here (to different pages)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopNavBar(),
      body: Center(
        child: Text(
          'Welcome, $role!',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        role: role,
        onTabSelected: _onTabSelected,
        selectedIndex: _selectedIndex,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AuthService().signOut(),
        tooltip: 'Logout',
        child: const Icon(Icons.logout),
      ),
    );
  }
}
