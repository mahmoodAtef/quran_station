import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_station/src/core/exceptions/exception_handler.dart';
import 'package:quran_station/src/core/utils/navigation_manager.dart';
import 'package:quran_station/src/modules/audios/presentation/screens/search_for_reciter_screen.dart';
import 'package:quran_station/src/modules/main/presentation/widgets/app_bar.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/styles_manager.dart';
import '../../../main/presentation/widgets/components.dart';
import '../../bloc/audios_bloc.dart';
import '../widgets/components.dart';

class AudiosMainScreen extends StatelessWidget {
  const AudiosMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    AudiosBloc bloc = AudiosBloc.get();

    return Scaffold(
      key: scaffoldKey,
      drawer: appDrawer,
      appBar: CustomAppBar(
        height: 9.h,
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
        title: Text(
          'الصوتيات',
          style: TextStylesManager.appBarTitle,
        ),
        actions: [
          IconButton(
              onPressed: () {
                context.push(const SearchForReciterScreen());
              },
              icon: const Icon(
                Icons.search,
                color: ColorManager.black,
              )),
        ],
      ),
      body: BlocListener<AudiosBloc, AudiosState>(
        bloc: bloc,
        listener: (context, state) {
          _handleExceptionS(context, state);
          if (state is GetAllRecitersSuccessState) {
            bloc.add(GetFavoriteRecitersEvent());
          }
        },
        child: BlocBuilder<AudiosBloc, AudiosState>(
          bloc: bloc,
          builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(4.0.w),
                  child: SizedBox(
                    height: 6.h,
                    width: 90.w,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          bloc.add(ChangeTabEvent(index));
                        },
                        child: TabWidget(
                          index: index,
                        ),
                      ),
                      separatorBuilder: (context, index) => SizedBox(
                        width: 2.0.w,
                      ),
                      itemCount: bloc.tabs.length,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(6.w),
                    child: BlocBuilder<AudiosBloc, AudiosState>(
                      bloc: bloc,
                      builder: (context, state) {
                        return bloc.audioTabsWidgets[bloc.currentTab];
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _handleExceptionS(BuildContext context, AudiosState state) {
    if (state is AudiosError) {
      ExceptionHandler.handle(state.exception);
      Navigator.pop(context);
    }
  }
}
