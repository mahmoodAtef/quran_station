import 'package:flutter/material.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/components.dart';

import '../../../main/presentation/widgets/connectivity.dart';

class TafsirPage extends StatelessWidget {
  const TafsirPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ConnectionWidget(
      onRetry: () {},
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: 114,
        itemBuilder: (context, index) => SizedBox(
            child: SurahTafsirItem(
          index: index,

        )),
        separatorBuilder: (context, index) {
          return const Divider();
        },
      ),
    );
  }
}
