import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/exceptions/exception_manager.dart';
import '../components.dart';

class AllRecitersPage extends StatelessWidget {
  const AllRecitersPage({super.key});

  @override
  Widget build(BuildContext context) {
    AudiosBloc bloc = AudiosBloc.get();
    return BlocListener<AudiosBloc, AudiosState>(
      listener: (context, state) {
        if (state is GetAllRecitersErrorState) {
          ExceptionManager(state.exception).showMessages(context);
        }
      },
      child: Padding(
        padding: EdgeInsets.all(5.0.w),
        child: RecitersList(reciters: bloc.reciters),
      ),
    );
  }
}