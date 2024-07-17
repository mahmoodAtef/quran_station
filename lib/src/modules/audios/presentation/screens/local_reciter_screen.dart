import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_station/src/core/utils/color_manager.dart';
import 'package:quran_station/src/core/utils/navigation_manager.dart';
import 'package:quran_station/src/core/utils/styles_manager.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import 'package:quran_station/src/modules/audios/presentation/screens/audio_player_screen.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/components.dart';
import 'package:sizer/sizer.dart';

class LocalReciterScreen extends StatelessWidget {
  final Directory reciterDirectory;

  const LocalReciterScreen({super.key, required this.reciterDirectory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          reciterDirectory.path.split('/').last,
          style: TextStylesManager.appBarTitle,
        ),
      ),
      body: BlocBuilder<AudiosBloc, AudiosState>(
        bloc: AudiosBloc.get(),
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(5.w),
            child: ListView.separated(
              itemBuilder: (context, index) => ItemWidget(
                title: reciterDirectory.listSync()[index].path.split('/').last,
                onPressed: () {
                  context.push(AudioPlayerScreen(
                      audioAddress: reciterDirectory.listSync()[index].path,
                      title: reciterDirectory
                          .listSync()[index]
                          .path
                          .split('/')
                          .last,
                      audioType: AudioType.file));
                },
                suffix: IconButton(
                  onPressed: () {
                    _confirmDelete(
                        context, reciterDirectory.listSync()[index].path);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: ColorManager.white,
                  ),
                ),
              ),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: reciterDirectory.listSync().length,
            ),
          );
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
              defaultToast(msg: "تم حذف التسجيل بنجاح");
              context.pop();
            }
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            title: const Text(
              "حذف التسجيل",
              style: TextStylesManager.appBarTitle,
            ),
            content: const Text(
              'هل تريد حذف هذا التسجيل؟',
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
                  AudiosBloc.get().add(DeleteDownloadedItemEvent(path, true));
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
