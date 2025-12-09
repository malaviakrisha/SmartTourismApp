import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'artist/add_shop_page.dart';

class MarketplacePage extends StatefulWidget {
  final String role;
  const MarketplacePage({Key? key, required this.role}) : super(key: key);

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
        actions: [
          // Only show Add button for artist
          if (widget.role == 'artist')
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddShopPage()),
                );
              },
            ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
        _db.collection('marketplace').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final shops = snapshot.data!.docs;

          if (shops.isEmpty) {
            return const Center(child: Text('No shops found.'));
          }

          return ListView.builder(
            itemCount: shops.length,
            itemBuilder: (context, index) {
              final data = shops[index].data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: ListTile(
                  leading: data['imageUrl'] != null
                      ? Image.network(data['imageUrl'],
                      width: 60, height: 60, fit: BoxFit.cover)
                      : const Icon(Icons.store),
                  title: Text(data['name'] ?? ''),
                  subtitle: Text(data['category'] ?? ''),
                  trailing: widget.role == 'admin'
                      ? IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await _db.collection('marketplace').doc(shops[index].id).delete();
                    },
                  )
                      : null,
                  onTap: () {
                    // TODO: Navigate to shop details if needed
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
