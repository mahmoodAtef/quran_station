import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_station/src/core/utils/navigation_manager.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import 'package:quran_station/src/modules/audios/presentation/screens/audio_player_screen.dart';
import 'package:sizer/sizer.dart';

class LocalReciterScreen extends StatelessWidget {
  final Directory reciterDirectory;

  const LocalReciterScreen({super.key, required this.reciterDirectory});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: theme.appBarTheme.elevation,
        centerTitle: true,
        title: Text(
          reciterDirectory.path.split('/').last,
          style: theme.appBarTheme.titleTextStyle ??
              theme.textTheme.titleLarge?.copyWith(
                color: theme.appBarTheme.foregroundColor ??
                    theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
        ),
        iconTheme: theme.appBarTheme.iconTheme,
      ),
      body: BlocBuilder<AudiosBloc, AudiosState>(
        bloc: AudiosBloc.get(),
        builder: (context, state) {
          final audioFiles = reciterDirectory.listSync();

          if (audioFiles.isEmpty) {
            return _buildEmptyState(theme);
          }

          return Container(
            color: theme.scaffoldBackgroundColor,
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                // Header with count
                Container(
                  padding: EdgeInsets.all(3.w),
                  margin: EdgeInsets.only(bottom: 2.h),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: theme.shadowColor.withOpacity(0.1),
                        blurRadius: 6.0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.audiotrack,
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'عدد التسجيلات: ${audioFiles.length}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Audio files list
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => _buildAudioItem(
                      context,
                      theme,
                      audioFiles[index],
                      index,
                    ),
                    separatorBuilder: (context, index) => Divider(
                      color: theme.dividerColor,
                      thickness: 0.5,
                      height: 2.h,
                    ),
                    itemCount: audioFiles.length,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 80,
            color: theme.colorScheme.outline,
          ),
          SizedBox(height: 2.h),
          Text(
            'لا توجد ملفات صوتية',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'لم يتم العثور على أي ملفات صوتية في هذا المجلد',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAudioItem(
    BuildContext context,
    ThemeData theme,
    FileSystemEntity audioFile,
    int index,
  ) {
    final fileName = audioFile.path.split('/').last;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.5.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.08),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          splashColor: theme.colorScheme.primary.withOpacity(0.1),
          highlightColor: theme.colorScheme.primary.withOpacity(0.05),
          onTap: () {
            context.push(AudioPlayerScreen(
              audioAddress: audioFile.path,
              title: fileName,
              audioType: AudioType.file,
            ));
          },
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: Row(
              children: [
                // Audio icon
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(
                    Icons.play_circle_filled,
                    color: theme.colorScheme.primary,
                    size: 28,
                  ),
                ),

                SizedBox(width: 4.w),

                // File info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fileName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'ملف صوتي محلي',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                // Delete button
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: IconButton(
                    onPressed: () {
                      _confirmDelete(context, audioFile.path, fileName);
                    },
                    icon: Icon(
                      Icons.delete_outline,
                      color: theme.colorScheme.error,
                      size: 22,
                    ),
                    tooltip: 'حذف التسجيل',
                    splashColor: theme.colorScheme.error.withOpacity(0.2),
                    highlightColor: theme.colorScheme.error.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String path, String fileName) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BlocListener<AudiosBloc, AudiosState>(
          bloc: AudiosBloc.get(),
          listener: (context, state) {
            if (state is DeleteDownloadedItemSuccessState) {
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: theme.colorScheme.onInverseSurface,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'تم حذف التسجيل بنجاح',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onInverseSurface,
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: theme.colorScheme.inverseSurface,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
              context.pop();
            }
          },
          child: AlertDialog(
            backgroundColor: theme.dialogBackgroundColor,
            surfaceTintColor: theme.colorScheme.surfaceTint,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            icon: Icon(
              Icons.delete_forever,
              color: theme.colorScheme.error,
              size: 48,
            ),
            title: Text(
              'حذف التسجيل',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'هل تريد حذف هذا التسجيل؟',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 1.h),
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    fileName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.onSurface,
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'إلغاء',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  AudiosBloc.get().add(DeleteDownloadedItemEvent(path, true));
                },
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.onError,
                  backgroundColor: theme.colorScheme.error,
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'حذف',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onError,
                  ),
                ),
              ),
            ],
            actionsPadding: EdgeInsets.fromLTRB(3.w, 0, 3.w, 2.h),
          ),
        );
      },
    );
  }
}
