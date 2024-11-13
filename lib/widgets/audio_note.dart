import 'package:audioplayers/audioplayers.dart';
import 'package:audio_wave/audio_wave.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/controllers/audio_controller.dart';
import 'package:voice_message_package/voice_message_package.dart';

class AudioNote extends StatefulWidget {
  @override
  _AudioNoteState createState() => _AudioNoteState();
}

class _AudioNoteState extends State<AudioNote> {
  final AudioController audioVM = Get.find<AudioController>();
  final AudioPlayer _audioPlayer = AudioPlayer();
  String audioUrl = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"; // Replace with your audio URL

  late final VoiceController _voiceController;


  @override
  void initState() {
    super.initState();

    // Initialize the VoiceController here
    _voiceController = VoiceController(
      noiseCount: 50,
      audioSrc: audioUrl,
      maxDuration: Duration(seconds: 60),
      isFile: false,
      onComplete: () {
        // Handle audio complete
      },
      onPause: () {
        // Handle pause
      },
      onPlaying: () {
        // Handle playing state
      },
      onError: (err) {
        // Handle errors
      },
    );
  }

  @override
  void dispose() {
    // Dispose of VoiceController and AudioPlayer
    _voiceController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayPause() async {
    if (audioVM.isPLaying.value) {
      await _audioPlayer.pause();
    } else {
      audioVM.isLoading.value = true;
      await _audioPlayer.play(UrlSource(audioUrl));
      audioVM.isLoading.value = false;
    }
    audioVM.isPLaying.value = !audioVM.isPLaying.value;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Play/Pause Button
        // Obx(
        //   () => GestureDetector(
        //     onTap: _togglePlayPause,
        //     child: Container(
        //       height: 36.w,
        //       width: 36.w,
        //       decoration: BoxDecoration(
        //         color: AppColors.secondary,
        //         shape: BoxShape.circle,
        //       ),
        //       alignment: Alignment.center,
        //       child: Icon(
        //         audioVM.isPLaying.value ? Icons.pause : Icons.play_arrow,
        //         size: 30,
        //         color: AppColors.primary,
        //       ),
        //     ),
        //   ),
        // ),
        // SizedBox(width: 10.h),
        SizedBox(
          width: Get.width * 0.82,
          child: VoiceMessageView(
            size: 40,
            backgroundColor: Colors.black,
            activeSliderColor: Colors.white,
            circlesColor: Colors.white,
            playPauseButtonLoadingColor: AppColors.primary,
            playIcon: Icon(Icons.play_arrow, size: 30.w, color: Colors.black,),
            pauseIcon: Icon(Icons.pause, size: 30.w, color: Colors.black,),
            circlesTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),

            counterTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            controller: _voiceController,
            innerPadding: 0,
            cornerRadius: 20,
          // waveformHeight: 60,
          ),
        ),

        // Audio Waveform
        // Obx(() {
        //   bool isPlaying = audioVM.isPLaying.value;
        //
        //   return AudioWave(
        //     height: 40,
        //     width: MediaQuery.of(context).size.width * 0.7,
        //     spacing: 2,
        //     bars: [
        //       AudioWaveBar(heightFactor: 0.1, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.3, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.7, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.4, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.4, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.3, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.2, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.1, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.3, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.3, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.7, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.7, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.4, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.3, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.4, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.1, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.4, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.1, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.3, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.7, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.4, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.4, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.3, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.2, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.1, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.3, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.3, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.7, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.7, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.4, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.3, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.4, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.1, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.4, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.1, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.3, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.7, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.4, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.4, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.3, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.2, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.1, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.3, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.3, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.7, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.7, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.4, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.3, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.4, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.1, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.4, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.1, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.3, color: isPlaying ? Colors.white : Colors.grey),
        //       AudioWaveBar(heightFactor: 0.7, color: isPlaying ? Colors.white : Colors.grey),
        //     ],
        //     animation: isPlaying, // Animate only when audio is playing
        //   );
        // }),
      ],
    );
  }
}
