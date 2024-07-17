import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import 'package:quran_station/src/modules/audios/data/models/reciter/reciter_model.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/components.dart';
import 'package:quran_station/src/modules/main/presentation/widgets/app_bar.dart';
import 'package:quran_station/src/modules/main/presentation/widgets/components.dart';
import 'package:quran_station/src/modules/main/presentation/widgets/connectivity.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils/color_manager.dart';

class SearchForReciterScreen extends StatelessWidget {
  const SearchForReciterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Reciter> searchByNameResult = [];
    TextEditingController controller = TextEditingController();
    AudiosBloc bloc = AudiosBloc.get();
    return Scaffold(
      appBar: CustomAppBar(
        actions: [
          Padding(
            padding: EdgeInsetsDirectional.only(end: 5.w),
            child: const Icon(
              Icons.search,
              color: ColorManager.black,
            ),
          ),
        ],
        height: 10.h,
        leadingWidth: 10.w,
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.all(5.w),
          child: DefaultTextFeild(
            controller: controller,
            onChanged: (value) {
              bloc.add(SearchByNameEvent(value));
            },
            hintText: 'ابحث عن القارئ',
            keyboardType: TextInputType.text,
          ),
        ),
      ),
      body: BlocListener<AudiosBloc, AudiosState>(
        listener: (context, state) {
          if (state is GetSearchByNameResult) {
            searchByNameResult = state.result;
          }
        },
        child: BlocBuilder<AudiosBloc, AudiosState>(
          bloc: bloc,
          builder: (context, state) {
            return ConnectionWidget(
              onRetry: () {
                if (controller.text != "") {
                  bloc.add(SearchByNameEvent(controller.text));
                }
              },
              child: Padding(
                padding: EdgeInsets.all(6.0.w),
                child: ListView.separated(
                    itemBuilder: (context, index) =>
                        ReciterItem(reciter: searchByNameResult[index]),
                    separatorBuilder: (context, index) =>
                        const HeightSeparator(),
                    itemCount: searchByNameResult.length),
              ),
            );
          },
        ),
      ),
    );
  }
}
