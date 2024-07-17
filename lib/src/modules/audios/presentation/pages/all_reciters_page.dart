import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/reciters_list.dart';
import 'package:quran_station/src/modules/main/presentation/widgets/connectivity.dart';

class AllRecitersPage extends StatelessWidget {
  const AllRecitersPage({super.key});

  @override
  Widget build(BuildContext context) {
    AudiosBloc bloc = AudiosBloc.get()
      ..add(GetAllRecitersEvent());
    return ConnectionWidget(
        onRetry: () {
          bloc.add(GetAllRecitersEvent());
        },
        child: BlocBuilder<AudiosBloc, AudiosState>(
          bloc: bloc,
          builder: (context, state) {
            return Column(
              children: [
                state is GetAllRecitersLoadingState
                    ? const LinearProgressIndicator()
                    : const SizedBox(),
               bloc.reciters.isEmpty ? const SizedBox() :  Expanded(child: RecitersList(reciters: bloc.reciters)),
              ],
            );
          },
        ));
  }
}
