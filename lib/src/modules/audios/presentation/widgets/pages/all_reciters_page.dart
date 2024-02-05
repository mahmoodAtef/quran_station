import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import '../components.dart';

class AllRecitersPage extends StatelessWidget {
  const AllRecitersPage({super.key});

  @override
  Widget build(BuildContext context) {
    AudiosBloc bloc = AudiosBloc.get()..add(GetAllRecitersEvent());
    print("AllRecitersPage");
    return BlocBuilder<AudiosBloc, AudiosState>(
      bloc: bloc,
      builder: (context, state) {
        return RecitersList(reciters: bloc.reciters);
      },
    );
  }
}
