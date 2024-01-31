import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerScreen extends StatelessWidget {
  final String audioUrl;
  final String title;
  const AudioPlayerScreen({super.key, required this.audioUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    // Initial playback. Preloaded playback information
    AudioPlayer audioPlayer = AudioPlayer(handleInterruptions: true);

    audioPlayer.positionStream.listen((event) {
      debugPrint("Position: ${event.inSeconds}");
    });
    audioPlayer.setCanUseNetworkResourcesForLiveStreamingWhilePaused(true);
    playAudio(audioPlayer);
    debugPrint("Audio Url: $audioUrl");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Audio Player"),
      ),
      body: const Center(
        child: Column(
          children: [],
        ),
      ),
    );
  }

  Future playAudio(AudioPlayer audioPlayer) async {
    //await audioPlayer.stop();
    await audioPlayer.setUrl(audioUrl);
    //await audioPlayer.load();
    await audioPlayer.play();
  }
}
