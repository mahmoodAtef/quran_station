import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_station/src/core/utils/navigation_manager.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import 'package:quran_station/src/modules/audios/presentation/screens/local_reciter_screen.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/components.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/item_widget.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/toasts.dart';
import 'package:sizer/sizer.dart';

class NoInternetAudiosPage extends StatelessWidget {
  const NoInternetAudiosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                ? Center(
                    child: Text(
                      "لا توجد تسجيلات",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : ListView.separated(
                    itemBuilder: (context, index) => ItemWidget(
                      suffix: IconButton(
                        onPressed: () {
                          _confirmDelete(context, localReciters[index].path);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      onPressed: () {
                        context.push(LocalReciterScreen(
                            reciterDirectory: localReciters[index]));
                      },
                      title: localReciters[index].path.split("/").last,
                      subTitle:
                          "${localReciters[index].listSync().length} تسجيل",
                    ),
                    separatorBuilder: (context, index) => Divider(
                      color: theme.dividerColor,
                      thickness: theme.dividerTheme.thickness,
                    ),
                    itemCount: localReciters.length,
                  );
          } else {
            return Column(
              children: [
                LinearProgressIndicator(
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                ),
                const Spacer(),
              ],
            );
          }
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, String path) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return BlocListener<AudiosBloc, AudiosState>(
          bloc: AudiosBloc.get(),
          listener: (context, state) {
            if (state is DeleteDownloadedItemSuccessState) {
              defaultToast(msg: "تم حذف المجلد بنجاح", );
              context.pop();
            }
          },
          child: AlertDialog(
            backgroundColor: theme.dialogBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
              side: BorderSide(
                color: theme.colorScheme.outline.withOpacity(0.2),
              ),
            ),
            title: Text(
              "حذف المجلد",
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'هل تريد حذف جميع تسجيلات هذا المجلد؟',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.secondary,
                ),
                child: Text(
                  'إلغاء',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                ),
                child: Text(
                  'حذف',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  AudiosBloc.get().add(DeleteDownloadedItemEvent(path, false));
                },
              ),
            ],
            actionsPadding: EdgeInsetsDirectional.only(
              end: 5.w,
              bottom: 2.h,
            ),
          ),
        );
      },
    );
  }
}
