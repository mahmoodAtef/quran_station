import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_station/src/core/utils/constance_manager.dart';
import 'package:quran_station/src/core/utils/navigation_manager.dart';
import 'package:quran_station/src/core/utils/styles_manager.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import 'package:quran_station/src/modules/audios/presentation/screens/audio_player_screen.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/components.dart';

import '../../data/models/moshaf/moshaf.dart';

class MoshafScreen extends StatelessWidget {
  final Moshaf moshaf;
  const MoshafScreen({super.key, required this.moshaf});

  @override
  Widget build(BuildContext context) {
    // debugPrint("moshaf name is ${moshaf.surahList}");

    AudiosBloc bloc = AudiosBloc.get()..add(GetMoshafDetailsEvent(moshaf.moshafData.id));
    bloc.currentMoshaf = moshaf.moshafData.name;
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
                print(state.moshafDetails.server);
                moshaf.moshafDetails = state.moshafDetails;
              }
            },
            child: moshaf.moshafDetails != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                        addAutomaticKeepAlives: true,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          int surahId = moshaf.moshafDetails!.surahsIds[index];
                          return InkWell(
                            onTap: () {
                              if (kDebugMode) {
                                print(_getSurahUrl(surahId));
                              }
                              context.push(AudioPlayerScreen(
                                  audioType: AudioType.url,
                                  audioAddress: _getSurahUrl(surahId),
                                  title:
                                      "سورة ${ConstanceManager.quranSurahsNames[surahId - 1]}-${moshaf.moshafData.name}"));
                            },
                            child: SurahItem(
                              surahId: surahId,
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 10,
                            ),
                        itemCount: moshaf.moshafData.surahTotal),
                  )
                : const LinearProgressIndicator(),
          );
        },
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
