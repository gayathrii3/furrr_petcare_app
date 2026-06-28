import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../models/vet.dart';

class VetService {
  static final VetService _instance = VetService._internal();
  factory VetService() => _instance;
  VetService._internal();

  Future<List<Vet>> getNearbyVets() async {
    try {
      Position position = await _determinePosition();
      
      final lat = position.latitude;
      final lng = position.longitude;

      // Overpass QL query: Find elements with amenity=veterinary in a 15km radius of user
      final query = '[out:json];node["amenity"="veterinary"](around:15000,$lat,$lng);out;';
      
      final uri = Uri.parse('https://overpass-api.de/api/interpreter').replace(
        queryParameters: {'data': query},
      );

      print('Fetching OpenStreetMap vets near: $lat, $lng');
      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> elements = data['elements'] ?? [];
        
        return elements.map((json) => Vet.fromOsmJson(json, lat, lng)).toList();
      } else {
        throw Exception('Failed to load vets from OpenStreetMap');
      }
    } catch (e) {
      print('Error getting vets from OpenStreetMap: $e. Returning fallback demo data.');
      return _getDemoVets(); 
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
