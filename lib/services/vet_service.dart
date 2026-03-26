import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../models/vet.dart';

class VetService {
  static const String _apiKey = String.fromEnvironment('GOOGLE_MAPS_API_KEY');
  static const String _baseUrlNearby = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
  static const String _baseUrlDetails = 'https://maps.googleapis.com/maps/api/place/details/json';

  static final VetService _instance = VetService._internal();
  factory VetService() => _instance;
  VetService._internal();

  Future<List<Vet>> getNearbyVets() async {
    try {
      Position position = await _determinePosition();
      
      if (_apiKey.isEmpty || _apiKey == 'YOUR_GOOGLE_MAPS_API_KEY') {
        print("Google Maps API Key not set. Returning demo data.");
        return _getDemoVets();
      }

      final uri = Uri.parse(_baseUrlNearby).replace(
        queryParameters: {
          'location': '${position.latitude},${position.longitude}',
          'radius': '10000', // Increased radius to 10km
          'type': 'veterinary_care',
          'key': _apiKey,
        },
      );

      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];
        
        return results.map((json) => Vet.fromPlacesJson(json, position.latitude, position.longitude)).toList();
      } else {
        throw Exception('Failed to load vets: ${response.body}');
      }
    } catch (e) {
      print('Error getting vets: $e');
      return _getDemoVets(); 
    }
  }

  Future<String?> getVetPhoneNumber(String placeId) async {
    if (_apiKey.isEmpty || _apiKey == 'YOUR_GOOGLE_MAPS_API_KEY') return null;

    try {
      final uri = Uri.parse(_baseUrlDetails).replace(
        queryParameters: {
          'place_id': placeId,
          'fields': 'formatted_phone_number',
          'key': _apiKey,
        },
      );
      
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['result']?['formatted_phone_number'];
      }
    } catch (e) {
      print('Error fetching vet details: $e');
    }
    return null;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  List<Vet> _getDemoVets() {
    return [
      const Vet(
        name: "Happy Paws Clinic (Demo)",
        distance: "1.2 km",
        rating: 4.8,
        specialties: ["Surgery", "Vaccination"],
        isOpen: true,
        address: "Jubilee Hills, Hyderabad",
        phone: "+91 98765 43210",
        placeId: "demo_1",
        lat: 17.4326,
        lng: 78.4071,
      ),
      const Vet(
        name: "City Pet Hospital (Demo)",
        distance: "2.5 km",
        rating: 4.5,
        specialties: ["Emergency", "Dental Care"],
        isOpen: true,
        address: "Banjara Hills, Hyderabad",
        phone: "+91 87654 32109",
        placeId: "demo_2",
        lat: 17.4126,
        lng: 78.4171,
      ),
      const Vet(
        name: "Advanced Vet Care (Demo)",
        distance: "3.8 km",
        rating: 4.9,
        specialties: ["Surgery", "Internal Medicine"],
        isOpen: false,
        address: "Madhapur, Hyderabad",
        phone: "+91 76543 21098",
        placeId: "demo_3",
        lat: 17.4426,
        lng: 78.3871,
      ),
    ];
  }
}
