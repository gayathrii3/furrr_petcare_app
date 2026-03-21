import 'dart:convert';
import 'package:http/http.dart' as http;

class YouTubeService {
  // TODO: Replace with your actual YouTube Data API v3 Key
  static const String _apiKey = String.fromEnvironment('YOUTUBE_API_KEY');
  static const String _baseUrl = 'https://www.googleapis.com/youtube/v3';

  Future<List<Map<String, String>>> fetchPetVideos({String pageToken = ''}) async {
    if (_apiKey == 'YOUR_YOUTUBE_API_KEY') {
      // Returning mock data if API key is not set to avoid crashes during development
      return [
        {'id': '3_lAb6mH2t0', 'title': 'Golden Retriever playing'},
        {'id': 'nL_S6L7G0Ew', 'title': 'Funny Cat in grooming'},
        {'id': '5Xv1w9j190s', 'title': 'Pug puppy care'},
        {'id': '_S7Wv_X1W5c', 'title': 'Husky training shorts'},
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
