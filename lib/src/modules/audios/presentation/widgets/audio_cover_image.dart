// lib/src/modules/audios/presentation/widgets/audio_cover_image.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:quran_station/src/core/utils/images_manager.dart';
import 'package:quran_station/src/modules/audios/presentation/screens/audio_player_screen.dart';
import 'package:sizer/sizer.dart';

class AudioCoverImage extends StatelessWidget {
  final AudioType audioType;

  const AudioCoverImage({Key? key, required this.audioType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl =
    audioType == AudioType.radio ? ImagesManager.radioGif : ImagesManager.audioGif;

    return Expanded(
      child: Center(
        child: Container(
          height: 40.h,
          width: 90.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withOpacity(0.4),
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(0.15),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildImage(theme, imageUrl),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        theme.colorScheme.scrim.withOpacity(0.25),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(ThemeData theme, String imageUrl) {
    Widget placeholder() => Container(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: CircularProgressIndicator(color: theme.colorScheme.primary),
      ),
    );

    Widget errorWidget() => Container(
      color: theme.colorScheme.errorContainer,
      child: Icon(
        Icons.error_outline_rounded,
        color: theme.colorScheme.error,
        size: 12.w,
      ),
    );

    if (audioType == AudioType.radio) {
      return Image.asset(
        fit: BoxFit.cover,
       imageUrl,
      );
    }

    return Image.asset(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => errorWidget(),
    );
  }
}