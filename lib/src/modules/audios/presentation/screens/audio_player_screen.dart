import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_station/src/core/utils/images_manager.dart';
import 'package:quran_station/src/core/utils/styles_manager.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/audio_player.dart';
import 'package:quran_station/src/modules/main/presentation/widgets/connectivity.dart';
import 'package:sizer/sizer.dart';

enum AudioType { url, file, radio }

class AudioPlayerScreen extends StatefulWidget {
  final String audioAddress;
  final String title;
  final AudioType audioType;

  const AudioPlayerScreen({
    Key? key,
    required this.audioAddress,
    required this.title,
    required this.audioType,
  }) : super(key: key);

  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  AudiosBloc bloc = AudiosBloc.get();
  late AudioPlayer _audioPlayer;
  @override
  void initState() {
    super.initState();
    _audioPlayer = bloc.audioPlayer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStylesManager.appBarTitle,
        ),
      ),
      body: widget.audioType != AudioType.file
          ? ConnectionWidget(
              onRetry: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildImage(),
                  PlayerWidget(
                    player: _audioPlayer,
                    audioAddress: widget.audioAddress,
                    title: widget.title,
                    audioType: widget.audioType,
                  )
                ],
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildImage(),
                PlayerWidget(
                  player: _audioPlayer,
                  audioAddress: widget.audioAddress,
                  title: widget.title,
                  audioType: widget.audioType,
                )
              ],
            ),
    );
  }

  Widget _buildImage() {
    if (widget.audioType == AudioType.radio) {
      return Expanded(
          child: Center(
              child: SizedBox(
        height: 40.h,
        width: 90.w,
        child: CachedNetworkImage(fit: BoxFit.cover, imageUrl: ImagesManager.radioGif),
      )));
    } else if (widget.audioType == AudioType.url) {
      return Expanded(
          child: Center(
              child: SizedBox(
        height: 40.h,
        width: 90.w,
        child: CachedNetworkImage(fit: BoxFit.cover, imageUrl: ImagesManager.audioGif),
      )));
    }

    return Expanded(
        child: Center(
            child: SizedBox(
      height: 40.h,
      width: 90.w,
      child: CachedNetworkImage(imageUrl: ImagesManager.audioGif),
    )));
  }
}
