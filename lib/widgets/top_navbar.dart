import 'package:flutter/material.dart';
import '../screens/profile_page.dart'; // redirect here

class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  const TopNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      automaticallyImplyLeading: false, // remove back arrow
      titleSpacing: 10,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: App Logo
          Row(
            children: [
              Image.asset(
                'logo.png', // your logo path
                height: 40,
              ),
              const SizedBox(width: 10),
              const Text(
                'Smart Tourism',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),

          // Right: Profile Icon
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
            child: CircleAvatar(
              backgroundColor: Colors.grey[200],
              radius: 20,
              child: Image.asset(
                'icons/profile.png',
                height: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
