import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../models/vet.dart';

class VetService {
  static const String _apiKey = String.fromEnvironment('GOOGLE_MAPS_API_KEY');
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

  static final VetService _instance = VetService._internal();
  factory VetService() => _instance;
  VetService._internal();

  Future<List<Vet>> getNearbyVets() async {
    try {
      // 1. Get current position
      Position position = await _determinePosition();
      
      if (_apiKey.isEmpty || _apiKey == 'YOUR_GOOGLE_MAPS_API_KEY') {
        print("Google Maps API Key not set. Returning demo data.");
        return _getDemoVets();
      }

      // 2. Fetch from Google Places API
      final uri = Uri.parse(_baseUrl).replace(
        queryParameters: {
          'location': '${position.latitude},${position.longitude}',
          'radius': '5000',
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
      return _getDemoVets(); // Fallback to demo data on error
    }
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
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  List<Vet> _getDemoVets() {
    return [
      const Vet(
        name: "Happy Paws Clinic (Demo)",
        distance: "1.2 km",
        rating: 4.8,
        specialties: ["Surgery", "Vaccination", "Grooming"],
        isOpen: true,
        address: "123 Green Lane, Jubilee Hills",
        phone: "+91 98765 43210",
      ),
      const Vet(
        name: "City Pet Hospital (Demo)",
        distance: "2.5 km",
        rating: 4.5,
        specialties: ["Emergency", "Dental Care", "X-Ray"],
        isOpen: true,
        address: "45 Blue Road, Banjara Hills",
        phone: "+91 87654 32109",
      ),
      const Vet(
        name: "Advanced Vet Care (Demo)",
        distance: "3.8 km",
        rating: 4.9,
        specialties: ["Surgery", "Internal Medicine", "Oncology"],
        isOpen: false,
        address: "78 Pearl St, Madhapur",
        phone: "+91 76543 21098",
      ),
    ];
  }
}
