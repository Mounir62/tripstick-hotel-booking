class Hotel {
  final String name;
  final String location;
  final double rating;
  final String imageUrl;
  final String category;
  final double price;

  Hotel({
    required this.name,
    required this.location,
    required this.rating,
    required this.imageUrl,
    required this.category,
    required this.price,
  });

  factory Hotel.fromFirestore(Map<String, dynamic> data) {
    return Hotel(
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? 'Other',
      price: (data['price'] ?? 0).toDouble(),
    );
  }
}
