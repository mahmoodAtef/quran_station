import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_station/src/core/utils/color_manager.dart';
import 'package:quran_station/src/core/utils/navigation_manager.dart';
import 'package:quran_station/src/core/utils/styles_manager.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import 'package:quran_station/src/modules/audios/presentation/screens/local_reciter_screen.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/components.dart';
import 'package:sizer/sizer.dart';

class NoInternetAudiosPage extends StatelessWidget {
  const NoInternetAudiosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Directory> localReciters = [];
    AudiosBloc.get().add(GetDownloadedAudiosEvent());
    return BlocListener<AudiosBloc, AudiosState>(
      listener: (context, state) {
        if (state is GetDownloadedAudiosSuccessState) {
          print(state.localReciters);
          localReciters = state.localReciters;
        }

        if (state is DeleteDownloadedItemSuccessState) {
          localReciters.removeWhere((element) => element.path == state.path);
        }
      },
      child: BlocBuilder<AudiosBloc, AudiosState>(
        builder: (context, state) {
          if (state is! GetDownloadedAudiosLoadingState) {
            return localReciters.isEmpty
                ? const Center(
                    child: Text(
                    "لا توجد تسجيلات",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
                : ListView.separated(
                    itemBuilder: (context, index) => ItemWidget(
                      suffix: IconButton(
                        onPressed: () {
                          _confirmDelete(context, localReciters[index].path);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: ColorManager.white,
                        ),
                      ),
                      onPressed: () {
                        context.push(LocalReciterScreen(
                            reciterDirectory: localReciters[index]));
                      },
                      title: localReciters[index].path.split("/").last,
                      subTitle:
                          "${localReciters[index].listSync().length}  تسجيل",
                    ),
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: localReciters.length,
                  );
          } else {
            // يمكنك هنا عرض عنصر تحميل أو أي شيء آخر أثناء التحميل
            return Column(
              children: [LinearProgressIndicator(), Spacer()],
            );
          }
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, String path) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocListener<AudiosBloc, AudiosState>(
          bloc: AudiosBloc.get(),
          listener: (context, state) {
            if (state is DeleteDownloadedItemSuccessState) {
              defaultToast(msg: "تم حذف المجلد  بنجاح");
              context.pop();
            }
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            title: Text(
              "حذف المجلد",
              style: TextStylesManager.appBarTitle,
            ),
            content: Text(
              'هل تريد حذف جميع تسجيلات هذا المجلد؟',
              style: TextStylesManager.regularBoldStyle,
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('إلغاء'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('حذف'),
                onPressed: () {
                  AudiosBloc.get().add(DeleteDownloadedItemEvent(path, false));
                },
              ),
            ],
            actionsPadding: EdgeInsetsDirectional.only(end: 5.w, bottom: 2.h),
          ),
        );
      },
    );
  }
}
