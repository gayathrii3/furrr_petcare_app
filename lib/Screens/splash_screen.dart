import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'main_nav.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    _videoController = VideoPlayerController.asset('assets/videos/dog_splash_video.mp4')
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
        });
        _videoController.play();
        
        _videoController.addListener(() {
          if (!_navigated && _videoController.value.isInitialized && 
              _videoController.value.position >= _videoController.value.duration) {
            _navigateToHome();
          }
        });
      }).catchError((error) {
        // Fallback in case of error
        Timer(const Duration(seconds: 3), _navigateToHome);
      });

    // Fallback timer if video taking too long
    Timer(const Duration(seconds: 8), _navigateToHome);
  }

  void _navigateToHome() {
    if (_navigated) return;
    _navigated = true;
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNav()),
      );
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isVideoInitialized
          ? SizedBox.expand(
              child: Center(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: _videoController.value.size.width,
                    height: _videoController.value.size.height,
                    child: VideoPlayer(_videoController),
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}