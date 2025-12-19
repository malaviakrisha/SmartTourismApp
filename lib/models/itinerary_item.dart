class ItineraryItem {
  final String itineraryId;
  final String shopId;
  final String shopName;
  final String category;
  final int price;
  final String location;

  final int day;
  final String timeSlot;

  ItineraryItem({
    required this.itineraryId,
    required this.shopId,
    required this.shopName,
    required this.category,
    required this.price,
    required this.location,
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
      'location': location,
      'day': day,
      'timeSlot': timeSlot,
    };
  }
}
