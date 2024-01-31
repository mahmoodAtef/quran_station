import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_station/src/core/exceptions/exception_manager.dart';
import 'package:quran_station/src/core/utils/styles_manager.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/components.dart';
import 'package:quran_station/src/modules/main/presentation/widgets/app_bar.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils/color_manager.dart';
import '../../../main/presentation/widgets/components.dart';

class AllRecitersScreen extends StatelessWidget {
  const AllRecitersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    AudiosBloc bloc = AudiosBloc.get()..add(GetAllRecitersEvent());

    return Scaffold(
      key: scaffoldKey,
      drawer: appDrawer,
      appBar: CustomAppBar(
        height: 10.h,
        leadingWidth: 10.w,
        leading: IconButton(
            onPressed: () async {
              scaffoldKey.currentState!.openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: ColorManager.black,
            )),
        centerTitle: true,
        title: const Text(
          'القراء',
          style: TextStylesManager.blackTitle,
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: ColorManager.black,
              )),
        ],
      ),
      body: BlocListener<AudiosBloc, AudiosState>(
        listener: (context, state) {
          if (state is GetAllRecitersErrorState) {
            ExceptionManager(state.exception).showMessages(context);
          }
        },
        child: BlocBuilder<AudiosBloc, AudiosState>(
          bloc: bloc,
          builder: (context, state) {
            return state is GetAllRecitersLoadingState
                ? const LinearProgressIndicator()
                : Padding(
                    padding: EdgeInsets.all(5.0.w),
                    child: RecitersList(reciters: bloc.reciters),
                  );
          },
        ),
      ),
    );
  }
}
