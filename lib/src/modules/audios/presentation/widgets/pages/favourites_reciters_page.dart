import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import '../reciters_list.dart';

class FavouritesRecitersPage extends StatelessWidget {
  const FavouritesRecitersPage({super.key});

  @override
  Widget build(BuildContext context) {
    AudiosBloc bloc = AudiosBloc.get()..add(GetFavoriteRecitersEvent());
    return BlocBuilder<AudiosBloc, AudiosState>(
      bloc: bloc,
      builder: (context, state) {
        return RecitersList(reciters: bloc.favoriteReciters);
      },
    );
  }
}
