import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'pet_profile_service.dart';

class YouTubeService {
  // Use centralized API config
  static final String _apiKey = ApiConfig.youtubeKey;
  static const String _baseUrl = 'https://www.googleapis.com/youtube/v3';

  // Pool of query topics
  static const List<String> _queryPool = [
    'pet dog training tips|dog tricks',
    'funny dog compilations|funny puppies',
    'cute puppies playing|dog play time',
    'dog care hacks|pet parent tips',
    'dog grooming guide|dog washing tips',
    'dog health tips|veterinary advice',
  ];

  // Pool of search order modes
  static const List<String> _orderPool = [
    'relevance',
    'date',
    'viewCount',
  ];

  Future<List<Map<String, String>>> fetchPetVideos({String pageToken = ''}) async {
    if (_apiKey.isEmpty || _apiKey == 'YOUR_YOUTUBE_API_KEY') {
      print("YouTube API Key not set. Returning mock data.");
      return [
        {'id': '3_lAb6mH2t0', 'title': 'Golden Retriever playing', 'channelTitle': 'PetCare Center'},
        {'id': 'nL_S6L7G0Ew', 'title': 'Funny Cat in grooming', 'channelTitle': 'CatLovers'},
        {'id': '5Xv1w9j190s', 'title': 'Pug puppy care', 'channelTitle': 'Daily Pet'},
        {'id': '_S7Wv_X1W5c', 'title': 'Husky training shorts', 'channelTitle': 'Training 101'},
      ];
    }

    try {
      final random = Random();
      
      // 1. Select a random general query from the pool
      String selectedBase = _queryPool[random.nextInt(_queryPool.length)];

      // 2. Personalize the query with the pet's breed, if set
      try {
        final pet = PetProfileService().currentPet;
        if (pet.breed.isNotEmpty && pet.breed.toLowerCase() != 'indie' && pet.breed.toLowerCase() != 'mixed') {
          // e.g. "Pug puppy care|Pug dog"
          selectedBase += '|${pet.breed} puppy care|${pet.breed} dog';
        }
      } catch (e) {
        // Fallback silently if service isn't initialized
      }

      // 3. Select a random sorting order to keep content fresh
      final orderMode = _orderPool[random.nextInt(_orderPool.length)];

      final uri = Uri.parse(_baseUrl).replace(
        path: '/youtube/v3/search',
        queryParameters: {
          'part': 'snippet',
          'q': selectedBase,
          'type': 'video',
          'videoDuration': 'short',
          'maxResults': '10',
          'order': orderMode,
          'key': _apiKey,
          if (pageToken.isNotEmpty) 'pageToken': pageToken,
        },
      );
      print('Fetching YouTube videos from: ${uri.toString().split('key=')[0]}key=HIDDEN');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> items = data['items'];
        
        return items.map((item) {
          return {
            'id': item['id']['videoId'].toString(),
            'title': item['snippet']['title'].toString(),
            'description': item['snippet']['description'].toString(),
            'channelTitle': item['snippet']['channelTitle'].toString(),
            'nextPageToken': data['nextPageToken']?.toString() ?? '',
          };
        }).toList();
      } else {
        throw Exception('Failed to load YouTube videos: ${response.body}');
      }
    } catch (e) {
      print('Error fetching YouTube videos: $e');
      return [];
    }
  }
}
