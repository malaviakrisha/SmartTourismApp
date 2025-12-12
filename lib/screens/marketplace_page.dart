import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'artist/add_shop_page.dart';
import 'artist/shop_details_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MarketplacePage extends StatefulWidget {
  final String role; // "artist", "admin", "tourist"

  const MarketplacePage({required this.role, Key? key}) : super(key: key);

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  // tourist controls
  String searchQuery = "";
  String selectedCategory = "All";
  String sortOption = "None";

  Stream<QuerySnapshot> _getShopStream() {
    if (widget.role == "artist") {
      return FirebaseFirestore.instance
          .collection("marketplace")
          .where("ownerId", isEqualTo: userId)
          .snapshots();
    } else {
      return FirebaseFirestore.instance.collection("marketplace").snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Marketplace")),

      floatingActionButton: widget.role == "artist"
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddShopPage()),
          );
        },
        child: const Icon(Icons.add),
      )
          : null,

      body: Column(
        children: [
          if (widget.role == "tourist") ...[
            // SEARCH BAR
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "Search shops...",
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) {
                  setState(() => searchQuery = val.trim().toLowerCase());
                },
              ),
            ),

            // CATEGORY FILTER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButtonFormField<String>(
                value: selectedCategory,
                items: const [
                  DropdownMenuItem(value: "All", child: Text("All Categories")),
                  DropdownMenuItem(value: "Park", child: Text("Park")),
                  DropdownMenuItem(value: "Craft", child: Text("Craft")),
                  DropdownMenuItem(value: "Painting", child: Text("Painting")),
                  DropdownMenuItem(value: "Handmade", child: Text("Handmade")),
                ],
                onChanged: (val) => setState(() => selectedCategory = val!),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ),

            const SizedBox(height: 8),

            // SORT DROPDOWN
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButtonFormField<String>(
                value: sortOption,
                items: const [
                  DropdownMenuItem(value: "None", child: Text("Sort: None")),
                  DropdownMenuItem(
                      value: "LowToHigh", child: Text("Price: Low → High")),
                  DropdownMenuItem(
                      value: "HighToLow", child: Text("Price: High → Low")),
                ],
                onChanged: (val) => setState(() => sortOption = val!),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ),
          ],

          Expanded(
            child: StreamBuilder(
              stream: _getShopStream(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                List docs = snap.data!.docs;

                // FILTER: SEARCH
                if (searchQuery.isNotEmpty) {
                  docs = docs.where((doc) {
                    final name = doc['name'].toString().toLowerCase();
                    return name.contains(searchQuery);
                  }).toList();
                }

                // FILTER: CATEGORY
                if (selectedCategory != "All") {
                  docs = docs.where((doc) {
                    return doc['category'] == selectedCategory;
                  }).toList();
                }

                // SORT: PRICE
                if (sortOption == "LowToHigh") {
                  docs.sort((a, b) => a['price'].compareTo(b['price']));
                } else if (sortOption == "HighToLow") {
                  docs.sort((a, b) => b['price'].compareTo(a['price']));
                }

                if (docs.isEmpty) {
                  return const Center(child: Text("No shops found"));
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final shop = docs[index];

                    return ListTile(
                      leading: Image.network(
                        shop['imageUrl'],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      title: Text(shop['name']),
                      subtitle: Text(
                        "${shop['category']} • ₹${shop['price']}",
                      ),

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ShopDetailsPage(shopId: shop.id),
                          ),
                        );
                      },

                      trailing: (widget.role == "artist" ||
                          widget.role == "admin")
                          ? IconButton(
                        icon:
                        const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection("marketplace")
                              .doc(shop.id)
                              .delete();
                        },
                      )
                          : null,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
