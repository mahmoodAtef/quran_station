import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import 'package:quran_station/src/modules/audios/data/models/reciter_model.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/components.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils/styles_manager.dart';

class ReciterScreen extends StatelessWidget {
  final int reciterID;

  const ReciterScreen({super.key, required this.reciterID});

  @override
  Widget build(BuildContext context) {
    AudiosBloc bloc = AudiosBloc.get()..add(GetReciterEvent(reciterID));
    // print(reciter.moshaf.first.server);
    Reciter reciter = bloc.reciters.firstWhere((element) => element.data.id == reciterID);
    return BlocBuilder<AudiosBloc, AudiosState>(
      bloc: bloc,
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                reciter.data.name,
                style: TextStylesManager.blackTitle,
              ),
            ),
            body: state is GetReciterLoadingState || reciter.moshafs == null
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: EdgeInsets.all(6.0.w),
                    child: ListView.separated(
                        addAutomaticKeepAlives: true,
                        shrinkWrap: true,
                        itemBuilder: (context, index) =>
                            MoshafWidget(moshaf: reciter.moshafs![index]),
                        separatorBuilder: (context, index) => SizedBox(
                              height: 10,
                            ),
                        itemCount: reciter.moshafs!.length),
                  ));
      },
    );
  }
}
