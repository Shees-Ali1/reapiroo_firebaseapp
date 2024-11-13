// import 'package:chewie/chewie.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:video_player/video_player.dart';
// import '../controllers/video_controller.dart';
//
// class PostVideoPlayer extends StatefulWidget {
//   final String videoUrl;
//   final int index;
//
//   const PostVideoPlayer(
//       {super.key, required this.videoUrl, required this.index});
//
//   @override
//   _PostVideoPlayerState createState() => _PostVideoPlayerState();
// }
//
// class _PostVideoPlayerState extends State<PostVideoPlayer> {
//   late VideoPlayerController _controller;
//   final VideoController _videoController = Get.find();
//
//   @override
//   void initState() {
//     super.initState();
//     _controller =
//         _videoController.controllerForIndex(widget.index, widget.videoUrl)!;
//     _videoController.controllers[widget.index]!.initialize();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<VideoController>(builder: (video) {
//       return Stack(
//         children: [
//           Chewie(controller: video.cheiwcontrollers[widget.index]!),
//         ],
//       );
//     });
//   }
// }
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../controllers/video_controller.dart';

class VideoPlayer extends StatefulWidget {
  final String videoUrl;

  const VideoPlayer({required this.videoUrl});

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late VideoPlayerController _controller;
  ChewieController? _chewieController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    if (!_isInitialized) {
      _controller = VideoPlayerController.asset(widget.videoUrl);
      try {
        await _controller.initialize();
        _chewieController = ChewieController(
          videoPlayerController: _controller,
          autoPlay: false,
          looping: false,
        );
        setState(() {
          _isInitialized = true; // Ensure initialization happens only once
        });
      } catch (e) {
        // Handle any initialization errors
        print('Error initializing video player: $e');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _chewieController == null) {
      return Center(
          child: CircularProgressIndicator(
        color: Colors.white,
      ));
    }

    return Chewie(
      controller: _chewieController!,
    );
  }
}
