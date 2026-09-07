// lib/src/modules/audios/presentation/widgets/audio_download_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import 'package:quran_station/src/modules/audios/presentation/screens/audio_player_screen.dart';
import 'package:sizer/sizer.dart';

class AudioDownloadButton extends StatefulWidget {
  final AudiosBloc bloc;
  final String audioAddress;
  final AudioType audioType;

  const AudioDownloadButton({
    Key? key,
    required this.bloc,
    required this.audioAddress,
    required this.audioType,
  }) : super(key: key);

  @override
  State<AudioDownloadButton> createState() => _AudioDownloadButtonState();
}

class _AudioDownloadButtonState extends State<AudioDownloadButton> {
  DownloadStatus _status = DownloadStatus.notDownloaded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<AudiosBloc, AudiosState>(
      listener: (context, state) {
        if (state is DownloadAudioSuccessState) {
          setState(() => _status = DownloadStatus.downloaded);
        } else if (state is CheckDownloadedAudioSuccessState) {
          setState(() => _status = state.downloadStatus);
        }
      },
      child: BlocBuilder<AudiosBloc, AudiosState>(
        bloc: widget.bloc,
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.only(right: 3.w),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _buildContent(theme, state),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(ThemeData theme, AudiosState state) {
    if (_status == DownloadStatus.downloaded ||
        widget.audioType == AudioType.file) {
      return Icon(
        Icons.download_done_rounded,
        key: const ValueKey('done'),
        color: theme.colorScheme.primary,
        size: 6.w,
      );
    }

    final progress = widget.bloc.downloadProgresses[widget.audioAddress];
    if (state is DownloadAudioLoadingState && progress != null) {
      return SizedBox(
        key: const ValueKey('loading'),
        width: 5.5.w,
        height: 5.5.w,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: theme.colorScheme.primary,
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
        ),
      );
    }

    return IconButton(
      key: const ValueKey('download'),
      onPressed: _downloadAudio,
      icon: Icon(
        Icons.download_rounded,
        color: theme.appBarTheme.iconTheme?.color ?? theme.colorScheme.onSurface,
      ),
      tooltip: 'تحميل الصوت',
      splashColor: theme.colorScheme.primary.withOpacity(0.2),
      highlightColor: theme.colorScheme.primary.withOpacity(0.1),
    );
  }

  void _downloadAudio() {
    if (_status == DownloadStatus.notDownloaded &&
        widget.bloc.downloadProgresses[widget.audioAddress] == null) {
      widget.bloc.add(DownloadCurrentAudio(widget.audioAddress));
    }
  }
}