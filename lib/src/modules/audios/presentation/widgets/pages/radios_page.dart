import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/components.dart';

class RadiosPage extends StatelessWidget {
  const RadiosPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AudiosBloc bloc = AudiosBloc.get()..add(GetAllRadiosEvent());
    return BlocBuilder<AudiosBloc, AudiosState>(
      builder: (context, state) {
        return ListView.separated(
          shrinkWrap: true,
          itemCount: bloc.radios.length,
          itemBuilder: (context, index) => SizedBox(child: RadioItem(radio: bloc.radios[index])),
          separatorBuilder: (context, index) {
            return const Divider();
          },
        );
      },
    );
  }
}
