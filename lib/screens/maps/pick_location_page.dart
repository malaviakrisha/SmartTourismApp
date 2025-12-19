import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import './base_map_widget.dart';

class PickLocationPage extends StatefulWidget {
  const PickLocationPage({super.key});

  @override
  State<PickLocationPage> createState() => _PickLocationPageState();
}

class _PickLocationPageState extends State<PickLocationPage> {
  LatLng? selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick Shop Location"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: selected == null
                ? null
                : () => Navigator.pop(context, selected),
          ),
        ],
      ),
      body: BaseMapWidget(
        center: const LatLng(20.5937, 78.9629),
        markers: selected == null
            ? []
            : [
          Marker(
            point: selected!,
            width: 40,
            height: 40,
            child: const Icon(
              Icons.location_pin,
              color: Colors.red,
              size: 40,
            ),
          ),
        ],
        onTap: (point) {
          setState(() => selected = point);
        },
      ),
    );
  }
}
