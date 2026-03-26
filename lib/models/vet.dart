class Vet {
  final String name;
  final String distance;
  final double rating;
  final List<String> specialties;
  final bool isOpen;
  final String address;
  final String phone;
  final String? placeId;
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
    this.placeId,
    this.lat,
    this.lng,
  });

  factory Vet.fromPlacesJson(Map<String, dynamic> json, double currentLat, double currentLng) {
    final location = json['geometry']?['location'];
    final lat = location != null ? (location['lat'] as num).toDouble() : null;
    final lng = location != null ? (location['lng'] as num).toDouble() : null;
    
    // Simple distance calculation (rough estimate in km)
    double distanceKm = 0;
    if (lat != null && lng != null) {
      distanceKm = _calculateDistance(currentLat, currentLng, lat, lng);
    }

    return Vet(
      name: json['name'] ?? 'Unknown Clinic',
      distance: lat != null ? "${distanceKm.toStringAsFixed(1)} km" : "Distance unknown",
      rating: (json['rating'] ?? 0.0).toDouble(),
      specialties: _parseTypes(json['types'] ?? []),
      isOpen: json['opening_hours']?['open_now'] ?? true,
      address: json['vicinity'] ?? 'Address not available',
      phone: json['formatted_phone_number'] ?? '', // Might be missing in search, fetched in details later if needed
      placeId: json['place_id'],
      lat: lat,
      lng: lng,
    );
  }

  static List<String> _parseTypes(List<dynamic> types) {
    if (types.contains('veterinary_care')) {
      return ["Veterinary", "Emergency Clinic"];
    }
    return ["Animal Hospital"];
  }

  static double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return ((lat2 - lat1).abs() + (lon2 - lon1).abs()) * 111.0;
  }
}
