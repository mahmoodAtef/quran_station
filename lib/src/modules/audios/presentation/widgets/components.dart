import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quran_station/src/core/utils/color_manager.dart';
import 'package:quran_station/src/core/utils/constance_manager.dart';
import 'package:quran_station/src/core/utils/navigation_manager.dart';
import 'package:quran_station/src/modules/audios/data/models/radio/radio.dart';
import 'package:quran_station/src/modules/audios/data/models/tafsir/tafsir.dart';
import 'package:quran_station/src/modules/audios/presentation/screens/audio_player_screen.dart';
import 'package:quran_station/src/modules/audios/presentation/screens/reciter_screen.dart';
import 'package:quran_station/src/modules/audios/presentation/screens/surah_tafsir_screen.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils/styles_manager.dart';
import '../../bloc/audios_bloc.dart';
import '../../data/models/moshaf/moshaf.dart';
import '../../data/models/reciter/reciter_model.dart';
import '../screens/mushaf_screen.dart';

void errorToast({
  required String msg,
}) {
  Fluttertoast.showToast(
    msg: msg,
    backgroundColor: ColorManager.error,
    toastLength: Toast.LENGTH_SHORT,
  );
}

void defaultToast({
  required String msg,
}) {
  Fluttertoast.showToast(
    msg: msg,
    backgroundColor: ColorManager.darkBlue,
    toastLength: Toast.LENGTH_SHORT,
  );
}

class ReciterItem extends StatelessWidget {
  final Reciter reciter;

  const ReciterItem({super.key, required this.reciter});

  @override
  Widget build(BuildContext context) {
    AudiosBloc bloc = AudiosBloc.get();
    return ItemWidget(
      onPressed: () {
        context.push(ReciterScreen(
          reciterID: reciter.data.id,
        ));
      },
      title: reciter.data.name,
      subTitle: '${reciter.data.rewayasCount}'
          ' قراءة / ${reciter.data.surahsCount} تسجيل ',
      suffix: Padding(
        padding: EdgeInsets.all(8.0.sp),
        child: BlocBuilder<AudiosBloc, AudiosState>(
          bloc: bloc,
          builder: (context, state) {
            return IconButton(
              onPressed: () {
                if (bloc.favoriteReciters.contains(reciter)) {
                  bloc.add(RemoveReciterFromFavoritesEvent(reciter.data.id));
                } else {
                  bloc.add(AddReciterToFavoritesEvent(reciter.data.id));
                }
              },
              icon: Icon(
                Icons.favorite,
                color: bloc.favoriteReciters.contains(reciter)
                    ? ColorManager.secondary
                    : ColorManager.white,
              ),
            );
          },
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
    return ItemWidget(
      onPressed: () {
        context.push(MoshafScreen(moshaf: moshaf));
      },
      title: moshaf.moshafData.name,
      subTitle: '${moshaf.moshafData.surahTotal} تسجيل ',
    );
  }
}

class SurahItem extends StatelessWidget {
  final int surahId;

  const SurahItem({super.key, required this.surahId});

  @override
  Widget build(BuildContext context) {
    int surahIndex = surahId - 1;
    return Card(
      child: ListTile(
        title: Text(ConstanceManager.quranSurahsNames[surahIndex]),
      ),
    );
  }
}

class TabWidget extends StatelessWidget {
  final int index;

  const TabWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    AudiosBloc bloc = AudiosBloc.get();
    return InkWell(
      onTap: () {
        bloc.add(ChangeTabEvent(index));
      },
      child: BlocBuilder<AudiosBloc, AudiosState>(
        bloc: bloc,
        builder: (context, state) {
          return Container(
            alignment: Alignment.center,
            height: 4.0.h,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.sp),
              color: bloc.currentTab == index
                  ? ColorManager.primary
                  : ColorManager.grey1,
            ),
            child: Text(
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              "${bloc.tabs[index]}  ",
              style: bloc.currentTab == index
                  ? TextStylesManager.selectedTabStyle
                  : TextStylesManager.unSelectedTabStyle,
            ),
          );
        },
      ),
    );
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel radio;

  const RadioItem({super.key, required this.radio});

  @override
  Widget build(BuildContext context) {
    return ItemWidget(
      onPressed: () {
        AudiosBloc bloc = AudiosBloc.get();
        bloc.currentReciter = "راديو";
        context.push(AudioPlayerScreen(
            audioAddress: radio.url,
            title: radio.name,
            audioType: AudioType.radio));
      },
      title: radio.name,
      icon: Icons.radio,
    );
  }
}

class SurahTafsirItem extends StatelessWidget {
  final int index;

  const SurahTafsirItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    String surahName = ConstanceManager.quranSurahsNames[index];
    return InkWell(
      onTap: () {
        context.push(SurahTafsirScreen(
          surahId: index + 1,
          surahName: surahName,
        ));
        // context.push(AudioPlayerScreen(
        //     audioAddress: radio.url, title: radio.name, audioType: AudioType.radio));
      },
      child: Card(
        surfaceTintColor: ColorManager.error,
        shape: ShapeBorder.lerp(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.sp),
          ),
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.sp)),
          1,
        ),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.sp),
              color: ColorManager.darkBlue,
              gradient: LinearGradient(
                colors: [
                  ColorManager.darkBlue.withOpacity(0.8),
                  // ColorManager.darkBlue.withOpacity(0.7),
                  // ColorManager.darkBlue.withOpacity(0.8),
                  // ColorManager.darkBlue.withOpacity(0.9),
                  ColorManager.darkBlue,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                // Padding(
                //   padding: EdgeInsetsDirectional.only(start: 5.sp),
                //   child: const Icon(
                //     Icons.ht,
                //     color: ColorManager.white,
                //   ),
                // ),
                Expanded(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          "تفسير سورة $surahName",
                          style: TextStylesManager.regularBoldWhiteStyle,
                        ),
                        // trailing: Text(reciter.count.toString()),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

class TafsirItem extends StatelessWidget {
  final Tafsir tafsir;

  const TafsirItem({super.key, required this.tafsir});

  @override
  Widget build(BuildContext context) {
    return ItemWidget(
      onPressed: () {
        AudiosBloc bloc = AudiosBloc.get();
        bloc.currentReciter = "الخلاصة من تفسير الطبري";
        context.push(AudioPlayerScreen(
            audioAddress: tafsir.url,
            title: tafsir.name,
            audioType: AudioType.url));
      },
      title: tafsir.name,
      icon: Icons.mic,
    );
  }
}

class ItemWidget extends StatelessWidget {
  final void Function() onPressed;
  final String title;
  final IconData? icon;
  final Widget? suffix;
  final String? subTitle;

  const ItemWidget(
      {super.key,
      required this.onPressed,
      required this.title,
      this.icon,
      this.suffix,
      this.subTitle});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        shape: ShapeBorder.lerp(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.sp),
          ),
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.sp)),
          1,
        ),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.sp),
              color: ColorManager.darkBlue,
              gradient: LinearGradient(
                colors: [
                  ColorManager.darkBlue.withOpacity(0.8),
                  ColorManager.darkBlue,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                if (icon != null)
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 5.sp),
                    child: Icon(
                      icon!,
                      color: ColorManager.white,
                    ),
                  ),
                Expanded(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          title,
                          style: TextStylesManager.regularBoldWhiteStyle,
                        ),
                        subtitle: subTitle != null
                            ? Text(
                                subTitle!,
                                style: TextStylesManager.regularWhiteStyle,
                              )
                            : null,
                        // trailing: Text(reciter.count.toString()),
                      ),
                    ],
                  ),
                ),
                if (suffix != null) suffix!
              ],
            )),
      ),
    );
  }
}
