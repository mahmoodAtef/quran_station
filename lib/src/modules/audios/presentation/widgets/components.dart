import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quran_station/src/core/utils/color_manager.dart';
import 'package:quran_station/src/core/utils/constance_manager.dart';
import 'package:quran_station/src/core/utils/navigation_manager.dart';
import 'package:quran_station/src/modules/audios/presentation/screens/reciter_screen.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/utils/styles_manager.dart';
import '../../bloc/audios_bloc.dart';
import '../../data/models/moshaf.dart';
import '../../data/models/reciter_model.dart';
import '../screens/mushaf_screen.dart';

void defaultToast({
  required String msg,
}) {
  Fluttertoast.showToast(
    backgroundColor: ColorManager.primary,
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
  );
}

void warnToast({
  required String msg,
}) {
  Fluttertoast.showToast(
    msg: msg,
    backgroundColor: ColorManager.secondary,
    // textColor: ColorManager.white,
    toastLength: Toast.LENGTH_SHORT,
  );
}

void errorToast({
  required String msg,
}) {
  Fluttertoast.showToast(
    msg: msg,
    backgroundColor: ColorManager.error,
    toastLength: Toast.LENGTH_SHORT,
  );
}

class RecitersList extends StatelessWidget {
  final List<Reciter> reciters;
  const RecitersList({super.key, required this.reciters});

  @override
  Widget build(BuildContext context) {
    Map<String, List<Reciter>> groupedReciters = groupRecitersByLetter(reciters);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: groupedReciters.length,
      itemBuilder: (context, index) {
        String letter = groupedReciters.keys.elementAt(index);
        List<Reciter> recitersInGroup = groupedReciters[letter]!;
        return Column(
          children: [
            ListTile(
              title: Text(letter),
            ),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: recitersInGroup.map((reciter) {
                return ReciterItem(reciter: reciter);
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  Map<String, List<Reciter>> groupRecitersByLetter(List<Reciter> reciters) {
    Map<String, List<Reciter>> groupedReciters = {};

    reciters.sort((a, b) => a.data.letter.compareTo(b.data.letter));

    for (var reciter in reciters) {
      String letter = reciter.data.letter.toUpperCase();

      if (!groupedReciters.containsKey(letter)) {
        groupedReciters[letter] = [];
      }

      groupedReciters[letter]!.add(reciter);
    }
    groupedReciters.forEach((key, value) {
      value.sort((a, b) => a.data.name.compareTo(b.data.name));
    });
    return groupedReciters;
  }
}

class ReciterItem extends StatelessWidget {
  final Reciter reciter;
  const ReciterItem({super.key, required this.reciter});
  @override
  Widget build(BuildContext context) {
    AudiosBloc bloc = AudiosBloc.get();
    return InkWell(
      onTap: () {
        print(reciter.data.id);
        context.push(ReciterScreen(
          reciterID: reciter.data.id,
        ));
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
                Expanded(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          reciter.data.name,
                          style: TextStylesManager.regularBoldWhiteStyle,
                        ),
                        subtitle: Text(
                          '${reciter.data.rewayasCount}'
                          ' قراءة / ${reciter.data.surahsCount} تسجيل ',
                          style: TextStylesManager.regularWhiteStyle,
                        ),
                        // trailing: Text(reciter.count.toString()),
                      ),
                    ],
                  ),
                ),
                Padding(
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
              ],
            )),
      ),
    );
  }
}

class MoshafWidget extends StatelessWidget {
  final Moshaf moshaf;
  const MoshafWidget({super.key, required this.moshaf});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(MoshafScreen(moshaf: moshaf));
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
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    moshaf.moshafData.name,
                    style: TextStylesManager.regularBoldWhiteStyle,
                  ),
                  subtitle: Text(
                    '${moshaf.moshafData.surahTotal} تسجيل ',
                    style: TextStylesManager.regularWhiteStyle,
                  ),
                  // trailing: Text(reciter.count.toString()),
                ),
              ],
            )),
      ),
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
  final String title;
  final int index;
  const TabWidget({super.key, required this.title, required this.index});

  @override
  Widget build(BuildContext context) {
    AudiosBloc bloc = AudiosBloc.get();
    return InkWell(
      onTap: () {
        bloc.add(ChangeTabEvent(index));
      },
      child: Container(
        height: 5.0.h,
        constraints: BoxConstraints(
          minWidth: 20.w,
          maxWidth: 80.w,
        ),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.sp),
          color: bloc.currentTab == index ? ColorManager.primary : ColorManager.grey1,
        ),
        child: Text(
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          title,
          style: bloc.currentTab == index
              ? TextStylesManager.selectedTabStyle
              : TextStylesManager.unSelectedTabStyle,
        ),
      ),
    );
  }
}
