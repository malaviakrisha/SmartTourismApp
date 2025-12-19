import 'package:flutter/material.dart';
import 'package:smart_tourism/screens/admin/admin_booking_page.dart';
import 'package:smart_tourism/screens/artist/artist_booking_page.dart';
import 'package:smart_tourism/screens/user/tourist_booking_page.dart';
import '../services/auth_service.dart';

// Import all destination pages
import '../screens/map_page.dart';
import '../screens/marketplace_page.dart';
import '../screens/artist/payment_page.dart';
import '../screens/admin/dashboard_page.dart';
import '../screens/admin/feedback_page.dart';
import '../screens/user/itinerary/tourist_itinerary_page.dart';

class BottomNavBar extends StatefulWidget {
  final String role;
  final Function(int)? onTabSelected;
  final int selectedIndex;

  const BottomNavBar({
    super.key,
    required this.role,
    this.onTabSelected,
    required this.selectedIndex,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  // Get all nav items based on role
  List<BottomNavigationBarItem> _getItems() {
    switch (widget.role.toLowerCase()) {
      case 'tourist':
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Marketplace"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Itinerary"),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: "Maps"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Booking"),
        ];
      case 'artist':
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Marketplace"),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: "Payment"),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: "Maps"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Booking"),
        ];
      case 'admin':
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Marketplace"),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.feedback), label: "Feedback"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Booking"),
        ];
      default:
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.error), label: "Error"),
        ];
    }
  }

  // Navigation logic
  void _navigateToPage(int index) {
    final role = widget.role.toLowerCase();

    Widget targetPage;

    switch (role) {
      case 'tourist':
        switch (index) {
          case 0:
            targetPage = MarketplacePage(role: widget.role);
            break;
          case 1:
            targetPage = TouristItineraryPage();
            break;
          case 2:
            targetPage = const MapPage();
            break;
          case 3:
            targetPage = TouristBookingsPage();
            break;
          default:
            return;
        }
        break;

      case 'artist':
        switch (index) {
          case 0:
            targetPage = MarketplacePage(role: widget.role);
            break;
          case 1:
            targetPage = const PaymentPage();
            break;
          case 2:
            targetPage = const MapPage();
            break;
          case 3:
            targetPage = ArtistBookingsPage();
            break;
          default:
            return;
        }
        break;

      case 'admin':
        switch (index) {
          case 0:
            targetPage = MarketplacePage(role: widget.role);
            break;
          case 1:
            targetPage = const DashboardPage();
            break;
          case 2:
            targetPage = const FeedbackPage();
            break;
          case 3:
            targetPage = AdminBookingsPage();
            break;
          default:
            return;
        }
        break;

      default:
        return;
    }

    // Replace current page with the new one
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => targetPage),
    );

    if (widget.onTabSelected != null) widget.onTabSelected!(index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: _getItems(),
      currentIndex: widget.selectedIndex,
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      onTap: _navigateToPage,
      backgroundColor: Colors.white,
      elevation: 10,
    );
  }
}
