import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class YouTubeService {
  // Use centralized API config
  static const String _apiKey = ApiConfig.youtubeKey;
  static const String _baseUrl = 'https://www.googleapis.com/youtube/v3';

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
      final query = 'pet dogs|petcare|pet grooming|cute puppies|dog care tips';
      final uri = Uri.parse(_baseUrl).replace(
        path: '/youtube/v3/search',
        queryParameters: {
          'part': 'snippet',
          'q': query,
          'type': 'video',
          'videoDuration': 'short',
          'maxResults': '10',
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
