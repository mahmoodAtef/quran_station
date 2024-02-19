import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/components.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/reciters_list.dart';

class AllRecitersScreen extends StatelessWidget {
  const AllRecitersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AudiosBloc bloc = AudiosBloc()..add(GetAllRecitersEvent());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("القراء"),
      ),
      body: BlocBuilder<AudiosBloc, AudiosState>(
        bloc: bloc,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: RecitersList(reciters: bloc.reciters),
          );
        },
      ),
    );
  }
}
