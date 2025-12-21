class ItineraryItem {
  final String itineraryId;
  final String shopId;
  final String shopName;
  final String category;
  final int price;
  final String location;
  final double latitude;
  final double longitude;

  final int day;
  final String timeSlot;

  ItineraryItem({
    required this.itineraryId,
    required this.shopId,
    required this.shopName,
    required this.category,
    required this.price,
    required this.latitude,
    required this.location,
    required this.longitude,
    required this.day,
    required this.timeSlot,
  });

  Map<String, dynamic> toMap() {
    return {
      'itineraryId': itineraryId,
      'shopId': shopId,
      'shopName': shopName,
      'category': category,
      'price': price,
      'latitude': latitude,
      'location': location,
      'longitude':longitude,
      'day': day,
      'timeSlot': timeSlot,
    };
  }
}
