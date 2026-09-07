import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_station/src/core/utils/constance_manager.dart';
import 'package:quran_station/src/core/utils/navigation_manager.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import 'package:quran_station/src/modules/audios/presentation/screens/audio_player_screen.dart';
import 'package:quran_station/src/modules/main/presentation/widgets/connectivity.dart';
import 'package:sizer/sizer.dart';

import '../../data/models/moshaf/moshaf.dart';

class MoshafScreen extends StatelessWidget {
  final Moshaf moshaf;
  const MoshafScreen({super.key, required this.moshaf});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    AudiosBloc bloc = AudiosBloc.get()
      ..add(GetMoshafDetailsEvent(moshaf.moshafData.id));
    bloc.currentMoshaf = moshaf.moshafData.name;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: theme.appBarTheme.elevation,
        centerTitle: true,
        title: Text(
          moshaf.moshafData.name,
          style: theme.appBarTheme.titleTextStyle ??
              theme.textTheme.titleLarge?.copyWith(
                color: theme.appBarTheme.foregroundColor ??
                    theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
        ),
        iconTheme: theme.appBarTheme.iconTheme,
      ),
      body: ConnectionWidget(
        onRetry: () {
          bloc.add(GetMoshafDetailsEvent(moshaf.moshafData.id));
        },
        child: BlocBuilder<AudiosBloc, AudiosState>(
          bloc: bloc,
          builder: (context, state) {
            return BlocListener<AudiosBloc, AudiosState>(
              bloc: bloc,
              listener: (context, state) {
                if (state is GetMoshafDetailsSuccessState) {
                  moshaf.moshafDetails = state.moshafDetails;
                }
              },
              child: Container(
                color: theme.scaffoldBackgroundColor,
                child: moshaf.moshafDetails != null
                    ? _buildSurahsList(context, theme)
                    : _buildLoadingState(theme),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Loading animation with theme colors
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.1),
                  blurRadius: 8.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Quran icon
                Icon(
                  Icons.menu_book,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),

                SizedBox(height: 3.h),

                // Loading indicator
                SizedBox(
                  width: 40.w,
                  child: LinearProgressIndicator(
                    backgroundColor: theme.colorScheme.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary,
                    ),
                    minHeight: 6,
                  ),
                ),

                SizedBox(height: 2.h),

                Text(
                  'جاري تحميل السور...',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 1.h),

                Text(
                  moshaf.moshafData.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahsList(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        // Header with Moshaf info
        Container(
          margin: EdgeInsets.all(4.w),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16.0),
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
              // Quran icon
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Icon(
                  Icons.menu_book,
                  color: theme.colorScheme.primary,
                  size: 28,
                ),
              ),

              SizedBox(width: 4.w),

              // Moshaf details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      moshaf.moshafData.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'عدد السور: ${moshaf.moshafData.surahTotal}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Play all button
              IconButton(
                onPressed: () {
                  // TODO: Implement play all functionality
                },
                icon: Icon(
                  Icons.play_circle_filled,
                  color: theme.colorScheme.primary,
                  size: 32,
                ),
                tooltip: 'تشغيل الكل',
                splashColor: theme.colorScheme.primary.withOpacity(0.2),
                highlightColor: theme.colorScheme.primary.withOpacity(0.1),
              ),
            ],
          ),
        ),

        // Surahs list
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              border:
              BoxBorder.all(
                   color: theme.dividerColor.withValues(
                     alpha: .03
                   )
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.08),
                  blurRadius: 10.0,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: ListView.separated(
              addAutomaticKeepAlives: true,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(2.w),
              itemBuilder: (context, index) {
                int surahId = moshaf.moshafDetails!.surahsIds[index];
                return _buildSurahItem(context, theme, surahId, index);
              },
              separatorBuilder: (context, index) => Divider(
                color: theme.dividerColor.withValues(
                  alpha: 0.03,
                ),
                thickness: 0.5,
                height: 2.h,
                indent: 4.w,
                endIndent: 4.w,
              ),
              itemCount: moshaf.moshafData.surahTotal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSurahItem(
      BuildContext context, ThemeData theme, int surahId, int index) {
    final surahName = ConstanceManager.quranSurahsNames[surahId - 1];

    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.5.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          splashColor: theme.colorScheme.primary.withOpacity(0.1),
          highlightColor: theme.colorScheme.primary.withOpacity(0.05),
          onTap: () {
            final surahUrl = _getSurahUrl(surahId);
            if (kDebugMode) {
              print(surahUrl);
            }
            context.push(AudioPlayerScreen(
              audioType: AudioType.url,
              audioAddress: surahUrl,
              title: "سورة $surahName - ${moshaf.moshafData.name}",
            ));
          },
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: Row(
              children: [
                // Surah number
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$surahId',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 4.w),

                // Surah details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'سورة $surahName',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'السورة رقم $surahId',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                // Play icon
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getSurahUrl(int surahId) {
    String surahUrl = "";
    String surahsString = "";

    if (surahId < 10) {
      surahsString = "00$surahId";
    } else if (surahId < 100) {
      surahsString = "0$surahId";
    } else {
      surahsString = "$surahId";
    }

    surahUrl = "${moshaf.moshafDetails?.server}/$surahsString.mp3";
    return surahUrl;
  }
}
