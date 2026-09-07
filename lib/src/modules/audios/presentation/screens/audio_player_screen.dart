// lib/src/modules/audios/presentation/screens/audio_player_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_station/src/core/exceptions/exception_handler.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/audio_cover_image.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/audio_download_button.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/audio_player.dart';
import 'package:quran_station/src/modules/main/presentation/widgets/connectivity.dart';
import 'package:sizer/sizer.dart';

enum AudioType { url, file, radio }

enum DownloadStatus { downloading, downloaded, notDownloaded }

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
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final AudiosBloc bloc = AudiosBloc.get();
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = bloc.audioPlayer;
    bloc.add(CheckDownloadedEvent(widget.audioAddress));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<AudiosBloc, AudiosState>(
      listener: _handleBlocListener,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: _buildAppBar(theme),
        body: _buildBody(theme),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      foregroundColor: theme.appBarTheme.foregroundColor,
      elevation: theme.appBarTheme.elevation,
      iconTheme: theme.appBarTheme.iconTheme,
      title: Text(
        widget.title,
        style: theme.appBarTheme.titleTextStyle ??
            theme.textTheme.titleLarge?.copyWith(
              color: theme.appBarTheme.foregroundColor,
              fontWeight: FontWeight.bold,
            ),
      ),
      actions: [
        if (widget.audioType != AudioType.radio)
          AudioDownloadButton(
            bloc: bloc,
            audioAddress: widget.audioAddress,
            audioType: widget.audioType,
          ),
      ],
    );
  }

  Widget _buildBody(ThemeData theme) {
    final content = Container(
      color: theme.scaffoldBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.audioType != AudioType.file) _buildProgressBar(theme),
          AudioCoverImage(audioType: widget.audioType),
          SafeArea(
            
            child: PlayerWidget(
              player: _audioPlayer,
              audioAddress: widget.audioAddress,
              title: widget.title,
              audioType: widget.audioType,
            ),
          ),
        ],
      ),
    );

    if (widget.audioType == AudioType.file) return content;
    return ConnectionWidget(onRetry: () {}, child: content);
  }

  Widget _buildProgressBar(ThemeData theme) {
    return BlocBuilder<AudiosBloc, AudiosState>(
      bloc: bloc,
      builder: (context, state) {
        final progress = bloc.downloadProgresses[widget.audioAddress];
        if (state is! DownloadAudioLoadingState || progress == null) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              minHeight: 0.7.h,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor:
              AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
              value: (progress as double) >= .01 ? progress : null,
            ),
          ),
        );
      },
    );
  }

  void _handleBlocListener(BuildContext context, AudiosState state) {
    final theme = Theme.of(context);

    if (state is DownloadAudioSuccessState) {
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } else if (state is DownloadAudioErrorState) {
      ExceptionHandler.handle(state.exception);
    }
  }
}