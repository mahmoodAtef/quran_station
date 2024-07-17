import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_station/src/core/exceptions/exception_handler.dart';
import 'package:quran_station/src/core/utils/images_manager.dart';
import 'package:quran_station/src/core/utils/styles_manager.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/audio_player.dart';
import 'package:quran_station/src/modules/main/presentation/widgets/connectivity.dart';
import 'package:sizer/sizer.dart';

enum AudioType { url, file, radio }

enum DownloadStatus {
  downloading,
  downloaded,
  notDownloaded,
}

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
  final AudiosBloc bloc = AudiosBloc.get();
  late AudioPlayer _audioPlayer;

  late DownloadStatus downloadStatus;

  @override
  void initState() {
    downloadStatus = DownloadStatus.notDownloaded;
    _audioPlayer = bloc.audioPlayer;
    bloc.add(CheckDownloadedEvent(widget.audioAddress));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AudiosBloc, AudiosState>(
      listener: _handleBlocListener,
      child: BlocBuilder<AudiosBloc, AudiosState>(
        bloc: bloc,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                if (widget.audioType != AudioType.radio) _buildDownloadButton()
              ],
              title: Text(
                widget.title,
                style: TextStylesManager.appBarTitle,
              ),
            ),
            body: _buildBody(state),
          );
        },
      ),
    );
  }

  Widget _buildBody(AudiosState state) {
    return widget.audioType != AudioType.file
        ? ConnectionWidget(
            onRetry: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state is DownloadAudioLoadingState &&
                    bloc.downloadProgresses[widget.audioAddress] != null)
                  LinearProgressIndicator(
                    value: bloc.downloadProgresses[widget.audioAddress]
                                as double >=
                            .01
                        ? bloc.downloadProgresses[widget.audioAddress]
                        : null,
                  ),
                _buildImage(),
                BlocBuilder<AudiosBloc, AudiosState>(
                  bloc: bloc,
                  builder: (context, state) {
                    return PlayerWidget(
                      player: _audioPlayer,
                      audioAddress: widget.audioAddress,
                      title: widget.title,
                      audioType: widget.audioType,
                    );
                  },
                ),
              ],
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildImage(),
              BlocBuilder<AudiosBloc, AudiosState>(
                bloc: bloc,
                builder: (context, state) {
                  return PlayerWidget(
                    player: _audioPlayer,
                    audioAddress: widget.audioAddress,
                    title: widget.title,
                    audioType: widget.audioType,
                  );
                },
              ),
            ],
          );
  }

  Widget _buildImage() {
    String imageUrl = widget.audioType == AudioType.radio
        ? ImagesManager.radioGif
        : ImagesManager.audioGif;

    return Expanded(
      child: Center(
        child: SizedBox(
          height: 40.h,
          width: 90.w,
          child: widget.audioType == AudioType.radio
              ? CachedNetworkImage(fit: BoxFit.cover, imageUrl: imageUrl)
              : Image.network(imageUrl),
        ),
      ),
    );
  }

  void _handleBlocListener(BuildContext context, AudiosState state) {
    if (state is DownloadAudioSuccessState) {
      // Handle success state
    } else if (state is DownloadAudioErrorState) {
      ExceptionHandler.handle(state.exception);
    }
  }

  Widget _buildDownloadButton() {
    return SizedBox(
      child: BlocListener<AudiosBloc, AudiosState>(
        listener: (context, state) {
          if (state is DownloadAudioSuccessState) {
            setState(() {
              downloadStatus = DownloadStatus.downloaded;
            });
          }
          if (state is CheckDownloadedAudioSuccessState) {
            setState(() {
              downloadStatus = state.downloadStatus;
            });
          }
        },
        child: BlocBuilder<AudiosBloc, AudiosState>(
          bloc: bloc,
          builder: (context, state) {
            if (downloadStatus == DownloadStatus.downloaded ||
                widget.audioType == AudioType.file) {
              return const Icon(Icons.download_done);
            } else if (state is DownloadAudioLoadingState &&
                bloc.downloadProgresses[widget.audioAddress] != null) {
              return const SizedBox();
            } else {
              return IconButton(
                onPressed: _downloadAudio,
                icon: const Icon(Icons.download),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _downloadAudio() async {
    if ((downloadStatus == DownloadStatus.notDownloaded) &&
        bloc.downloadProgresses[widget.audioAddress] == null) {
      bloc.add(DownloadCurrentAudio(widget.audioAddress));
    }
  }
}
