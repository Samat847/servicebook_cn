import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'auth_screen.dart';
import 'main_screen.dart';
import '../services/car_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    debugPrint('[SplashScreen] Starting video initialization...');
    
    try {
      _controller = VideoPlayerController.asset(
        'assets/videos/Untitled_Video_2026-02-25_18-08.mp4',
      );

      await _controller!.initialize();
      
      debugPrint('[SplashScreen] Video initialized successfully');
      debugPrint('[SplashScreen] Video size: ${_controller!.value.size}');
      debugPrint('[SplashScreen] Video duration: ${_controller!.value.duration}');
      debugPrint('[SplashScreen] Aspect ratio: ${_controller!.value.aspectRatio}');

      if (!mounted) {
        debugPrint('[SplashScreen] Widget not mounted after initialization');
        return;
      }

      setState(() {
        _isInitialized = true;
      });

      _controller!.setLooping(false);
      
      // Set volume to 0 for iOS autoplay compatibility
      await _controller!.setVolume(0);
      
      _controller!.play();
      debugPrint('[SplashScreen] Video playback started');

      _controller!.addListener(_onVideoProgress);
    } catch (e, stackTrace) {
      debugPrint('[SplashScreen] Video initialization error: $e');
      debugPrint('[SplashScreen] Stack trace: $stackTrace');
      
      if (mounted) {
        setState(() {
          _hasError = true;
        });
        // Fallback: navigate after short delay if video fails
        Future.delayed(const Duration(seconds: 2), _navigateToNextScreen);
      }
    }
  }

  void _onVideoProgress() {
    if (_controller == null) return;

    final value = _controller!.value;
    
    // Skip if not initialized or duration is zero
    if (!value.isInitialized || value.duration == Duration.zero) return;

    final position = value.position;
    final duration = value.duration;

    // Navigate when video is near completion
    if (duration.inMilliseconds > 0 &&
        position.inMilliseconds >= duration.inMilliseconds - 100 &&
        !_isNavigating) {
      debugPrint('[SplashScreen] Video near completion, navigating...');
      _isNavigating = true;
      _navigateToNextScreen();
    }
  }

  Future<void> _navigateToNextScreen() async {
    if (!mounted) return;

    final isAuthenticated = await CarStorage.isAuthenticated();
    final profile = await CarStorage.loadUserProfile();
    final hasProfile = profile.isComplete;

    if (!mounted) return;

    final Widget nextScreen = isAuthenticated
        ? (hasProfile ? const MainScreen() : const AuthScreen())
        : const AuthScreen();

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.removeListener(_onVideoProgress);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Video player with safe dimension checks
            if (_isInitialized && 
                _controller != null && 
                _controller!.value.isInitialized &&
                _controller!.value.aspectRatio > 0)
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  ),
                ),
              ),

            // Dark overlay
            Container(
              color: Colors.black.withOpacity(0.3),
            ),

            // Loading indicator while video initializes
            if (!_isInitialized && !_hasError)
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.white,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Загрузка...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

            // Error state
            if (_hasError)
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.white,
                      size: 48,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'AvtoMAN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
