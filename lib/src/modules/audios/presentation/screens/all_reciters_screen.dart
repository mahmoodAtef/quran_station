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
import '../widgets/pages/all_reciters_page.dart';

class AllRecitersScreen extends StatelessWidget {
  const AllRecitersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    AudiosBloc bloc = AudiosBloc.get()
      ..add(GetAllRecitersEvent())
      ..add(GetFavoriteRecitersEvent());

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
          style: TextStylesManager.appBarTitle,
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
      body: SingleChildScrollView(
        child: BlocBuilder<AudiosBloc, AudiosState>(
          bloc: bloc,
          builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(5.0.w),
                  child: SizedBox(
                    height: 6.h,
                    width: 90.w,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) =>
                          TabWidget(title: bloc.tabs[index], index: index),
                      separatorBuilder: (context, index) => SizedBox(
                        width: 5.0.w,
                      ),
                      itemCount: bloc.tabs.length,
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.0.h,
                ),
                state is GetAllRecitersLoadingState
                    ? const LinearProgressIndicator()
                    : bloc.audioTabsWidgets[bloc.currentTab]
              ],
            );
          },
        ),
      ),
    );
  }
}
