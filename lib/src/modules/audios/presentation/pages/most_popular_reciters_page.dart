import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/reciters_list.dart';

import '../../../main/presentation/widgets/connectivity.dart';

class MostPopularRecitersPage extends StatelessWidget {
  const MostPopularRecitersPage({super.key});

  @override
  Widget build(BuildContext context) {
    AudiosBloc bloc = AudiosBloc.get()..add(GetMostPopularRecitersEvent());
    return BlocBuilder<AudiosBloc, AudiosState>(
      bloc: bloc,
      builder: (context, state) {
        return ConnectionWidget(child: RecitersList(reciters: bloc.mostPopularReciters));
      },
    );
  }
}
