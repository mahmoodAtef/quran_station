import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_station/src/core/exceptions/exception_handler.dart';
import 'package:quran_station/src/core/utils/images_manager.dart';
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
    final theme = Theme.of(context);

    return BlocListener<AudiosBloc, AudiosState>(
      listener: _handleBlocListener,
      child: BlocBuilder<AudiosBloc, AudiosState>(
        bloc: bloc,
        builder: (context, state) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: theme.appBarTheme.backgroundColor,
              foregroundColor: theme.appBarTheme.foregroundColor,
              elevation: theme.appBarTheme.elevation,
              actions: [
                if (widget.audioType != AudioType.radio) _buildDownloadButton()
              ],
              title: Text(
                widget.title,
                style: theme.appBarTheme.titleTextStyle ??
                    theme.textTheme.titleLarge?.copyWith(
                      color: theme.appBarTheme.foregroundColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              iconTheme: theme.appBarTheme.iconTheme,
            ),
            body: _buildBody(state),
          );
        },
      ),
    );
  }

  Widget _buildBody(AudiosState state) {
    final theme = Theme.of(context);

    return widget.audioType != AudioType.file
        ? ConnectionWidget(
            onRetry: () {},
            child: Container(
              color: theme.scaffoldBackgroundColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state is DownloadAudioLoadingState &&
                      bloc.downloadProgresses[widget.audioAddress] != null)
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      child: LinearProgressIndicator(
                        backgroundColor: theme.colorScheme.surfaceVariant,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                        value: bloc.downloadProgresses[widget.audioAddress]
                                    as double >=
                                .01
                            ? bloc.downloadProgresses[widget.audioAddress]
                            : null,
                      ),
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
            ),
          )
        : Container(
            color: theme.scaffoldBackgroundColor,
            child: Column(
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
            ),
          );
  }

  Widget _buildImage() {
    final theme = Theme.of(context);
    String imageUrl = widget.audioType == AudioType.radio
        ? ImagesManager.radioGif
        : ImagesManager.audioGif;

    return Expanded(
      child: Center(
        child: Container(
          height: 40.h,
          width: 90.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.1),
                blurRadius: 8.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: widget.audioType == AudioType.radio
                ? CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: imageUrl,
                    placeholder: (context, url) => Container(
                      color: theme.colorScheme.surfaceVariant,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: theme.colorScheme.errorContainer,
                      child: Icon(
                        Icons.error,
                        color: theme.colorScheme.error,
                        size: 48,
                      ),
                    ),
                  )
                : Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: theme.colorScheme.surfaceVariant,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: theme.colorScheme.primary,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: theme.colorScheme.errorContainer,
                      child: Icon(
                        Icons.error,
                        color: theme.colorScheme.error,
                        size: 48,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void _handleBlocListener(BuildContext context, AudiosState state) {
    final theme = Theme.of(context);

    if (state is DownloadAudioSuccessState) {
      // Show success message with theme colors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم التحميل بنجاح',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onInverseSurface,
            ),
          ),
          backgroundColor: theme.colorScheme.inverseSurface,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (state is DownloadAudioErrorState) {
      ExceptionHandler.handle(state.exception);
    }
  }

  Widget _buildDownloadButton() {
    final theme = Theme.of(context);

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
              return Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: Icon(
                  Icons.download_done,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              );
            } else if (state is DownloadAudioLoadingState &&
                bloc.downloadProgresses[widget.audioAddress] != null) {
              return Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    color: theme.colorScheme.primary,
                    backgroundColor: theme.colorScheme.surfaceVariant,
                  ),
                ),
              );
            } else {
              return IconButton(
                onPressed: _downloadAudio,
                icon: Icon(
                  Icons.download,
                  color: theme.appBarTheme.iconTheme?.color ??
                      theme.colorScheme.onSurface,
                ),
                tooltip: 'تحميل الصوت',
                splashColor: theme.colorScheme.primary.withOpacity(0.2),
                highlightColor: theme.colorScheme.primary.withOpacity(0.1),
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
