import 'package:flutter/material.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/components.dart';

import '../../data/models/reciter_model.dart';

class RecitersGroup extends StatelessWidget {
  final String letter;
  final List<Reciter> reciters;

  const RecitersGroup({super.key, required this.letter, required this.reciters});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text(letter),
        ),
        ListView.builder(
          itemBuilder: (context, int index) => ReciterItem(reciter: reciters[index]),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: reciters.length,
        ),
      ],
    );
  }
}
