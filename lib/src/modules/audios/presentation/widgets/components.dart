import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quran_station/src/core/utils/constance_manager.dart';
import 'package:quran_station/src/core/utils/navigation_manager.dart';
import 'package:quran_station/src/core/utils/theme_manager.dart';
import 'package:quran_station/src/modules/audios/data/models/radio/radio.dart';
import 'package:quran_station/src/modules/audios/data/models/tafsir/tafsir.dart';
import 'package:quran_station/src/modules/audios/presentation/screens/audio_player_screen.dart';
import 'package:quran_station/src/modules/audios/presentation/screens/reciter_screen.dart';
import 'package:quran_station/src/modules/audios/presentation/screens/surah_tafsir_screen.dart';
import 'package:sizer/sizer.dart';

import '../../bloc/audios_bloc.dart';
import '../../data/models/moshaf/moshaf.dart';
import '../../data/models/reciter/reciter_model.dart';
import '../screens/mushaf_screen.dart';

void errorToast({
  required String msg,
}) {
  Fluttertoast.showToast(
    msg: msg,
    backgroundColor: AppColors.error,
    textColor: AppColors.onError,
    toastLength: Toast.LENGTH_SHORT,
  );
}

void defaultToast({
  required String msg,
}) {
  Fluttertoast.showToast(
    msg: msg,
    backgroundColor: AppColors.primaryColor,
    textColor: AppColors.onPrimary,
    toastLength: Toast.LENGTH_SHORT,
  );
}

class ReciterItem extends StatelessWidget {
  final Reciter reciter;

  const ReciterItem({super.key, required this.reciter});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    AudiosBloc bloc = AudiosBloc.get();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: 4,
        shadowColor: colorScheme.shadow.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.sp),
        ),
        child: InkWell(
          onTap: () {
            context.push(ReciterScreen(reciterID: reciter.data.id));
          },
          borderRadius: BorderRadius.circular(16.sp),
          child: Container(
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.sp),
              gradient: LinearGradient(
                colors: [
                  colorScheme.surface,
                  colorScheme.surface.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                // Avatar with initials
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25.sp),
                    border: Border.all(
                      color: colorScheme.primary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.person,
                    color: colorScheme.primary,
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: 3.w),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reciter.data.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.sp),
                      Row(
                        children: [
                          Icon(
                            Icons.library_books_outlined,
                            size: 14.sp,
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                          SizedBox(width: 4.sp),
                          Text(
                            '${reciter.data.rewayasCount} قراءة',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Icon(
                            Icons.audiotrack,
                            size: 14.sp,
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                          SizedBox(width: 4.sp),
                          Text(
                            '${reciter.data.surahsCount} تسجيل',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Favorite button
                BlocBuilder<AudiosBloc, AudiosState>(
                  bloc: bloc,
                  builder: (context, state) {
                    final isFavorite = bloc.favoriteReciters.contains(reciter);
                    return Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color: isFavorite
                            ? colorScheme.primary.withOpacity(0.1)
                            : colorScheme.surface,
                        borderRadius: BorderRadius.circular(20.sp),
                        border: Border.all(
                          color: isFavorite
                              ? colorScheme.primary
                              : colorScheme.outline.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {
                          if (isFavorite) {
                            bloc.add(RemoveReciterFromFavoritesEvent(
                                reciter.data.id));
                          } else {
                            bloc.add(
                                AddReciterToFavoritesEvent(reciter.data.id));
                          }
                        },
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite
                              ? colorScheme.primary
                              : colorScheme.onSurface.withOpacity(0.6),
                          size: 16.sp,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MoshafWidget extends StatelessWidget {
  final Moshaf moshaf;

  const MoshafWidget({super.key, required this.moshaf});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: 3,
        shadowColor: colorScheme.shadow.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.sp),
        ),
        child: InkWell(
          onTap: () {
            context.push(MoshafScreen(moshaf: moshaf));
          },
          borderRadius: BorderRadius.circular(16.sp),
          child: Container(
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.sp),
              gradient: LinearGradient(
                colors: [
                  colorScheme.primaryContainer.withOpacity(0.3),
                  colorScheme.surface,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 50.sp,
                  height: 50.sp,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.sp),
                  ),
                  child: Icon(
                    Icons.menu_book,
                    color: colorScheme.primary,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 12.sp),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        moshaf.moshafData.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.sp),
                      Row(
                        children: [
                          Icon(
                            Icons.audiotrack,
                            size: 14.sp,
                            color: colorScheme.primary,
                          ),
                          SizedBox(width: 4.sp),
                          Text(
                            '${moshaf.moshafData.surahTotal} تسجيل',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16.sp,
                  color: colorScheme.onSurface.withOpacity(0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SurahItem extends StatelessWidget {
  final int surahId;

  const SurahItem({super.key, required this.surahId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    int surahIndex = surahId - 1;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
      child: Card(
        elevation: 2,
        shadowColor: colorScheme.shadow.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.sp),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.sp),
            color: colorScheme.surface,
          ),
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.sp, vertical: 4.sp),
            leading: Container(
              width: 40.sp,
              height: 40.sp,
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.sp),
              ),
              child: Center(
                child: Text(
                  surahId.toString(),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: Text(
              ConstanceManager.quranSurahsNames[surahIndex],
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Icon(
              Icons.play_circle_outline,
              color: colorScheme.primary,
              size: 24.sp,
            ),
          ),
        ),
      ),
    );
  }
}

class TabWidget extends StatelessWidget {
  final int index;

  const TabWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    AudiosBloc bloc = AudiosBloc.get();

    return BlocBuilder<AudiosBloc, AudiosState>(
      bloc: bloc,
      builder: (context, state) {
        final isSelected = bloc.currentTab == index;

        return GestureDetector(
          onTap: () {
            bloc.add(ChangeTabEvent(index));
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: Alignment.center,
            height: 6.h,
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.sp),
              color: isSelected ? colorScheme.primary : colorScheme.surface,
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.outline.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              bloc.tabs[index],
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelLarge?.copyWith(
                color: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurface.withOpacity(0.7),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel radio;

  const RadioItem({super.key, required this.radio});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: 3,
        shadowColor: colorScheme.shadow.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.sp),
        ),
        child: InkWell(
          onTap: () {
            AudiosBloc bloc = AudiosBloc.get();
            bloc.currentReciter = "راديو";
            context.push(AudioPlayerScreen(
                audioAddress: radio.url,
                title: radio.name,
                audioType: AudioType.radio));
          },
          borderRadius: BorderRadius.circular(16.sp),
          child: Container(
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.sp),
              gradient: LinearGradient(
                colors: [
                  colorScheme.secondaryContainer.withOpacity(0.3),
                  colorScheme.surface,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 50.sp,
                  height: 50.sp,
                  decoration: BoxDecoration(
                    color: colorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25.sp),
                  ),
                  child: Icon(
                    Icons.radio,
                    color: colorScheme.secondary,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 12.sp),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        radio.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.sp),
                      Row(
                        children: [
                          Icon(
                            Icons.live_tv,
                            size: 14.sp,
                            color: colorScheme.secondary,
                          ),
                          SizedBox(width: 4.sp),
                          Text(
                            'بث مباشر',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.secondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.sp),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.sp),
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    color: colorScheme.secondary,
                    size: 20.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SurahTafsirItem extends StatelessWidget {
  final int index;

  const SurahTafsirItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    String surahName = ConstanceManager.quranSurahsNames[index];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: 4,
        shadowColor: colorScheme.shadow.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.sp),
        ),
        child: InkWell(
          onTap: () {
            context.push(SurahTafsirScreen(
              surahId: index + 1,
              surahName: surahName,
            ));
          },
          borderRadius: BorderRadius.circular(16.sp),
          child: Container(
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.sp),
              gradient: LinearGradient(
                colors: [
                  colorScheme.tertiaryContainer.withOpacity(0.6),
                  colorScheme.surface,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 50.sp,
                  height: 50.sp,
                  decoration: BoxDecoration(
                    color: colorScheme.tertiary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.sp),
                  ),
                  child: Icon(
                    Icons.library_books,
                    color: colorScheme.onSurface,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 12.sp),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "تفسير سورة $surahName",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.sp),
                      Row(
                        children: [
                          Icon(
                            Icons.school,
                            size: 14.sp,
                            color: colorScheme.onSurface,
                          ),
                          SizedBox(width: 4.sp),
                          Text(
                            'تفسير وتأويل',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16.sp,
                  color: colorScheme.onSurface.withOpacity(0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TafsirItem extends StatelessWidget {
  final Tafsir tafsir;

  const TafsirItem({super.key, required this.tafsir});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: 3,
        shadowColor: colorScheme.shadow.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.sp),
        ),
        child: InkWell(
          onTap: () {
            AudiosBloc bloc = AudiosBloc.get();
            bloc.currentReciter = "الخلاصة من تفسير الطبري";
            context.push(AudioPlayerScreen(
                audioAddress: tafsir.url,
                title: tafsir.name,
                audioType: AudioType.url));
          },
          borderRadius: BorderRadius.circular(16.sp),
          child: Container(
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.sp),
              gradient: LinearGradient(
                colors: [
                  colorScheme.primaryContainer.withOpacity(0.2),
                  colorScheme.surface,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 50.sp,
                  height: 50.sp,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25.sp),
                  ),
                  child: Icon(
                    Icons.mic,
                    color: colorScheme.primary,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 12.sp),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tafsir.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.sp),
                      Row(
                        children: [
                          Icon(
                            Icons.headphones,
                            size: 14.sp,
                            color: colorScheme.primary,
                          ),
                          SizedBox(width: 4.sp),
                          Text(
                            'تسجيل صوتي',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.sp),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.sp),
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    color: colorScheme.primary,
                    size: 20.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ItemWidget extends StatefulWidget {
  final void Function() onPressed;
  final String title;
  final IconData? icon;
  final Widget? suffix;
  final String? subTitle;

  const ItemWidget({
    super.key,
    required this.onPressed,
    required this.title,
    this.icon,
    this.suffix,
    this.subTitle,
  });

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            child: Material(
              elevation: _isPressed ? 1 : 4,
              shadowColor: colorScheme.shadow.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20.sp),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.sp),
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                            colorScheme.surface,
                            colorScheme.surface.withOpacity(0.95),
                          ]
                        : [
                            colorScheme.surface,
                            colorScheme.surfaceVariant.withOpacity(0.3),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: colorScheme.outline.withOpacity(0.08),
                    width: 1,
                  ),
                ),
                child: InkWell(
                  onTap: widget.onPressed,
                  onTapDown: (_) {
                    setState(() => _isPressed = true);
                    _controller.forward();
                  },
                  onTapUp: (_) {
                    setState(() => _isPressed = false);
                    _controller.reverse();
                  },
                  onTapCancel: () {
                    setState(() => _isPressed = false);
                    _controller.reverse();
                  },
                  borderRadius: BorderRadius.circular(20.sp),
                  splashColor: colorScheme.primary.withOpacity(0.08),
                  highlightColor: colorScheme.primary.withOpacity(0.05),
                  child: Container(
                    padding: EdgeInsets.all(18.sp),
                    child: Row(
                      children: [
                        // أيقونة محسّنة
                        if (widget.icon != null)
                          Container(
                            width: 52.sp,
                            height: 52.sp,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  colorScheme.primary.withOpacity(0.15),
                                  colorScheme.primary.withOpacity(0.08),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16.sp),
                              border: Border.all(
                                color: colorScheme.primary.withOpacity(0.1),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              widget.icon!,
                              color: colorScheme.primary,
                              size: 24.sp,
                            ),
                          ),

                        if (widget.icon != null) SizedBox(width: 14.sp),

                        // المحتوى النصي
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.onSurface,
                                  height: 1.3,
                                  letterSpacing: 0.2,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (widget.subTitle != null) ...[
                                SizedBox(height: 6.sp),
                                Text(
                                  widget.subTitle!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color:
                                        colorScheme.onSurface.withOpacity(0.65),
                                    height: 1.4,
                                    letterSpacing: 0.1,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),

                        // العنصر الإضافي مع تحسينات
                        if (widget.suffix != null) ...[
                          SizedBox(width: 8.sp),
                          Container(
                            padding: EdgeInsets.all(4.sp),
                            decoration: BoxDecoration(
                              color:
                                  colorScheme.surfaceVariant.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8.sp),
                            ),
                            child: widget.suffix!,
                          ),
                        ] else ...[
                          SizedBox(width: 8.sp),
                          Container(
                            padding: EdgeInsets.all(8.sp),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12.sp),
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: colorScheme.primary.withOpacity(0.7),
                              size: 16.sp,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
