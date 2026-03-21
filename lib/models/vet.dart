class Vet {
  final String name;
  final String distance;
  final double rating;
  final List<String> specialties;
  final bool isOpen;
  final String address;
  final String phone;
  final double? lat;
  final double? lng;

  const Vet({
    required this.name,
    required this.distance,
    required this.rating,
    required this.specialties,
    required this.isOpen,
    required this.address,
    required this.phone,
    this.lat,
    this.lng,
  });

  factory Vet.fromPlacesJson(Map<String, dynamic> json, double currentLat, double currentLng) {
    final location = json['geometry']['location'];
    final lat = location['lat'] as double;
    final lng = location['lng'] as double;
    
    // Simple distance calculation (rough estimate in km)
    final distanceKm = _calculateDistance(currentLat, currentLng, lat, lng);

    return Vet(
      name: json['name'] ?? 'Unknown Clinic',
      distance: "${distanceKm.toStringAsFixed(1)} km",
      rating: (json['rating'] ?? 0.0).toDouble(),
      specialties: _parseTypes(json['types'] ?? []),
      isOpen: json['opening_hours']?['open_now'] ?? true, // Default to true if unknown
      address: json['vicinity'] ?? 'Address not available',
      phone: 'Contact via Maps', // Nearby Search doesn't always include phone
      lat: lat,
      lng: lng,
    );
  }

  static List<String> _parseTypes(List<dynamic> types) {
    if (types.contains('veterinary_care')) {
      return ["Veterinary", "Checkup"];
    }
    return ["General"];
  }

  static double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    // Very basic Haversine-like calculation for display purposes
    return ((lat2 - lat1).abs() + (lon2 - lon1).abs()) * 111.0;
  }
}
