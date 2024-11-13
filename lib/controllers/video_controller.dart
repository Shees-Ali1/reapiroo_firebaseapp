// import 'package:chewie/chewie.dart';
// import 'package:get/get.dart';
// import 'package:video_player/video_player.dart';
//
// class VideoController extends GetxController {
//   late VideoPlayerController videoPlayerController;
//   late ChewieController chewieController;
//
//   Map<int, VideoPlayerController> controllers = {};
//   Map<int, ChewieController> cheiwcontrollers = {};
//
//   VideoPlayerController? controllerForIndex(int index, String videoUrl) {
//     if (!controllers.containsKey(index)) {
//       controllers[index] = VideoPlayerController.asset(videoUrl);
//       cheiwcontrollers[index] = ChewieController(
//           videoPlayerController: controllers[index]!,
//           autoPlay: true,
//           showOptions: false,
//           showControlsOnInitialize: false,
//           aspectRatio: 16 / 9);
//     }
//     return controllers[index];
//   }
// }
import 'package:chewie/chewie.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoController extends GetxController {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  // Method to initialize a single video
  VideoPlayerController initializeSingleVideo(String videoUrl) {
    videoPlayerController = VideoPlayerController.asset(videoUrl);

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      showOptions: false,
      showControlsOnInitialize: false,
      aspectRatio: 16 / 9,
    );

    return videoPlayerController;
  }

  @override
  void dispose() {
    // Dispose the controllers when no longer needed
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }
}
