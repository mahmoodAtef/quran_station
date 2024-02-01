import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quran_station/src/core/utils/color_manager.dart';
import 'package:quran_station/src/core/utils/constance_manager.dart';
import 'package:quran_station/src/core/utils/navigation_manager.dart';
import 'package:quran_station/src/modules/audios/presentation/screens/reciter_screen.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/utils/styles_manager.dart';
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
    print(surahId);
    return Card(
      child: ListTile(
        title: Text(ConstanceManager.quranSurahsNames[surahId - 1]),
      ),
    );
  }
}
