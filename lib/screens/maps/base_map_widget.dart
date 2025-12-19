import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class BaseMapWidget extends StatelessWidget {
  final LatLng center;
  final List<Marker> markers;
  final Function(LatLng)? onTap;

  const BaseMapWidget({
    super.key,
    required this.center,
    required this.markers,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: center,
        initialZoom: 13,
        onTap: onTap == null
            ? null
            : (tapPosition, point) => onTap!(point),
      ),
      children: [
        TileLayer(
          urlTemplate:
          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: const ['a', 'b', 'c'],
        ),
        MarkerLayer(markers: markers),
      ],
    );
  }
}
