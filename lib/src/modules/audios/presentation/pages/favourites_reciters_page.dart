import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_station/src/core/utils/styles_manager.dart';
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
        return ConnectionWidget(
            child: (bloc.favoriteReciters.isEmpty && state is! GetFavoriteRecitersLoadingState)
                ? const Center(
                    child: Text(
                      "لا يوجد قراء",
                      style: TextStylesManager.regularBoldStyle,
                    ),
                  )
                : Column(
                  children: [
                  state is GetFavoriteRecitersLoadingState ? const LinearProgressIndicator() : const SizedBox(),
                 bloc.favoriteReciters.isEmpty ? const SizedBox() :    Expanded(child: RecitersList(reciters: bloc.favoriteReciters)),
                  ],
                ));
      },
    );
  }
}
