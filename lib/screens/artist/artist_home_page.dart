import 'package:flutter/material.dart';
import '../../widgets/top_navbar.dart';
import '../../widgets/bottom_nav.dart';
import '../../services/auth_service.dart';
import '/auth.dart';
import '../marketplace_page.dart';

class ArtistHomePage extends StatefulWidget {
  const ArtistHomePage({super.key});

  @override
  State<ArtistHomePage> createState() => _ArtistHomePageState();
}

class _ArtistHomePageState extends State<ArtistHomePage> {
  int _selectedIndex = 0;
  String role = "artist"; // fallback until Firestore role is fetched

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  // Fetch role from Firestore
  void _loadRole() async {
    final fetchedRole = await AuthServiceHelper().getUserRole();
    if (fetchedRole != null) {
      setState(() => role = fetchedRole);
    }
  }

  void _onTabSelected(int index) {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0: // Marketplace tab
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MarketplacePage(role: role)),
        );
        break;
      case 1: // Itenary
      // Navigator.push(...);
        break;
      case 2: // Payment
      // Navigator.push(...);
        break;
      case 3: // Chatbot
      // Navigator.push(...);
        break;
    }
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
