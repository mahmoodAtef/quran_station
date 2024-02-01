import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_station/src/core/utils/constance_manager.dart';
import 'package:quran_station/src/core/utils/navigation_manager.dart';
import 'package:quran_station/src/core/utils/styles_manager.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import 'package:quran_station/src/modules/audios/presentation/screens/audioPlayerScreen.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/components.dart';

import '../../data/models/moshaf.dart';

class MoshafScreen extends StatelessWidget {
  final Moshaf moshaf;
  const MoshafScreen({super.key, required this.moshaf});

  @override
  Widget build(BuildContext context) {
    // debugPrint("moshaf name is ${moshaf.surahList}");

    AudiosBloc bloc = AudiosBloc.get()..add(GetMoshafDetailsEvent(moshaf.moshafData.id));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          moshaf.moshafData.name,
          style: TextStylesManager.appBarTitle,
        ),
      ),
      body: BlocBuilder<AudiosBloc, AudiosState>(
        bloc: bloc,
        builder: (context, state) {
          return BlocListener<AudiosBloc, AudiosState>(
            bloc: bloc,
            listener: (context, state) {
              if (state is GetMoshafDetailsSuccessState) {
                moshaf.moshafDetails = state.moshafDetails;
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                  addAutomaticKeepAlives: true,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          print(_getSurahUrl(index));
                          context.push(AudioPlayerScreen(
                              audioUrl: _getSurahUrl(index),
                              title:
                                  "سورة ${ConstanceManager.quranSurahsNames[index]}-${moshaf.moshafData.name}"));
                        },
                        child: SurahItem(
                          surahId: index,
                        ),
                      ),
                  separatorBuilder: (context, index) => SizedBox(
                        height: 10,
                      ),
                  itemCount: moshaf.moshafData.surahTotal),
            ),
          );
        },
      ),
    );
  }

  List<int> _getSurahsIndexesFromString(String surahsString) {
    List<int> surahs = [];
    debugPrint("https://server6.mp3quran.net/akdr/002.mp3");
    List<String> surahsStringList = surahsString.split(",");
    for (var element in surahsStringList) {
      surahs.add(int.parse(element) - 1);
    }
    return surahs;
  }

  String _getSurahUrl(int index) {
    String surahUrl = "";
    String surahsString = "";
    if (index < 10) {
      surahsString = "00${index + 1}";
    } else if (index < 100) {
      surahsString = "0${index + 1}";
    } else {
      surahsString = "${index + 1}";
    }
    surahUrl = "${moshaf.moshafDetails?.server}/$surahsString.mp3";

    print(surahUrl);
    return surahUrl;
  }
}
