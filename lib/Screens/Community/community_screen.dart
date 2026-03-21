import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../services/youtube_service.dart';
import 'package:share_plus/share_plus.dart';
import '../../widgets/custom_back_button.dart';
import '../../services/translation_service.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final List<Map<String, String>> _videos = [];
  bool _isLoading = false;
  String _nextPageToken = '';
  final YouTubeService _youtubeService = YouTubeService();

  @override
  void initState() {
    super.initState();
    _loadVideos();
    TranslationService().addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    TranslationService().removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadVideos() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final newVideos = await _youtubeService.fetchPetVideos(pageToken: _nextPageToken);
      setState(() {
        _videos.addAll(newVideos);
        if (newVideos.isNotEmpty && newVideos.first.containsKey('nextPageToken')) {
          _nextPageToken = newVideos.first['nextPageToken'] ?? '';
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _videos.isEmpty && _isLoading
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF52B788)))
              : PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: _videos.length,
            onPageChanged: (index) {
              if (index == _videos.length - 2) {
                _loadVideos();
              }
            },
            itemBuilder: (context, index) {
              final video = _videos[index];
              return CommunityShortItem(
                videoId: video['id'] ?? '',
                title: video['title'] ?? '',
                channelTitle: video['channelTitle'] ?? '',
              );
            },
          ),
          _buildOverlayHeader(),
        ],
      ),
    );
  }

  Widget _buildOverlayHeader() {
    return Positioned(
      top: 10,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.6),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          children: [
            const CustomBackButton(),
            const SizedBox(width: 8),
            Text(
              TranslationService.t('community'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommunityShortItem extends StatefulWidget {
  final String videoId;
  final String title;
  final String channelTitle;
  const CommunityShortItem({
    super.key,
    required this.videoId,
    required this.title,
    required this.channelTitle,
  });

  @override
  State<CommunityShortItem> createState() => _CommunityShortItemState();
}

class _CommunityShortItemState extends State<CommunityShortItem> {
  late YoutubePlayerController _controller;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        loop: true,
        hideControls: true,
        forceHD: false,
      ),
    )..addListener(() {
      if (mounted) {
        setState(() {
          _isPaused = !_controller.value.isPlaying;
        });
      }
    });
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onTap: _togglePlayPause,
          child: YoutubePlayer(
            controller: _controller,
            aspectRatio: 9 / 16,
            showVideoProgressIndicator: true,
            progressIndicatorColor: const Color(0xFF52B788),
          ),
        ),
        if (_isPaused)
          Center(
            child: Icon(
              Icons.play_arrow,
              color: Colors.white.withOpacity(0.5),
              size: 80,
            ),
          ),
        _buildSideActions(),
        _buildBottomInfo(),
      ],
    );
  }

  Widget _buildSideActions() {
    return Positioned(
      right: 16,
      bottom: 100,
      child: Column(
        children: [
          _actionIcon(Icons.favorite, "2.4k", Colors.redAccent, () {}),
          const SizedBox(height: 20),
          _actionIcon(Icons.comment, "128", Colors.white, () {}),
          const SizedBox(height: 20),
          _actionIcon(Icons.share, "Share", Colors.white, () {
            Share.share('Check out this pet video: https://www.youtube.com/watch?v=${widget.videoId}');
          }),
        ],
      ),
    );
  }

  Widget _actionIcon(IconData icon, String count, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 4),
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInfo() {
    return Positioned(
      left: 16,
      bottom: 20,
      right: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white24,
                child: Icon(Icons.person, color: Colors.white70, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.channelTitle.isNotEmpty ? "@${widget.channelTitle.replaceAll(' ', '')}" : "@PetLover",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  "Follow",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.title,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
