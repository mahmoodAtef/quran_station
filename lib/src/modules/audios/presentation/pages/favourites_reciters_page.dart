import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';

import '../../../main/presentation/widgets/connectivity.dart';
import '../../presentation/widgets/reciters_list.dart';

class FavouritesRecitersPage extends StatelessWidget {
  const FavouritesRecitersPage({super.key});

  @override
  Widget build(BuildContext context) {
    AudiosBloc bloc = AudiosBloc.get()..add(GetFavoriteRecitersEvent());
    return BlocBuilder<AudiosBloc, AudiosState>(
      bloc: bloc,
      builder: (context, state) {
        debugPrint("******************** Favourite Reciters ********************");
        debugPrint(bloc.favoriteReciters.toString());
        return ConnectionWidget(
            onRetry: () {
              bloc.add(GetFavoriteRecitersEvent());
            },
            child: (bloc.favoriteReciters.isEmpty &&
                    state is! GetFavoriteRecitersLoadingState)
                ? Center(
                    child: Text(

                      "لا يوجد قراء",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                : Column(
                    children: [
                      state is GetFavoriteRecitersLoadingState
                          ? const LinearProgressIndicator()
                          : const SizedBox(),
                      bloc.favoriteReciters.isEmpty
                          ? const SizedBox()
                          : Expanded(
                              child: RecitersList(
                                  reciters: bloc.favoriteReciters.toSet().toList())),
                    ],
                  ));
      },
    );
  }
}
