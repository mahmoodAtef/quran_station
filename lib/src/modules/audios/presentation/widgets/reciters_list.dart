import 'package:flutter/material.dart';
import 'package:quran_station/src/modules/audios/data/models/reciter_model.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/reciters_group.dart';
import 'package:quran_station/src/modules/main/presentation/widgets/components.dart';

class RecitersList extends StatefulWidget {
  final List<Reciter> reciters;
  const RecitersList({super.key, required this.reciters});

  @override
  State<RecitersList> createState() => _RecitersListState();
}

class _RecitersListState extends State<RecitersList> {
  List<MapEntry<String, List<Reciter>>> groupedRecitersList = [];
  int displayedGroupes = 2;
  ScrollController? _scrollController;

  @override
  void initState() {
    groupedRecitersList = _groupRecitersByLetter(widget.reciters);
    super.initState();
    if (_isLongList()) {
      _scrollController = ScrollController();
      _scrollController!.addListener(_scrollListener);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        itemCount: _isLongList() ? displayedGroupes + 1 : groupedRecitersList.length,
        itemBuilder: (context, index) {
          if (index > displayedGroupes - 1 && _isLongList()) {
            return const HeightSeparator();
          } else {
            return RecitersGroup(
                letter: groupedRecitersList[index].key, reciters: groupedRecitersList[index].value);
          }
        });
  }

  List<MapEntry<String, List<Reciter>>> _groupRecitersByLetter(List<Reciter> reciters) {
    Map<String, List<Reciter>> groupedReciters = {};
    reciters.sort((a, b) => a.data.letter.compareTo(b.data.letter));
    for (var reciter in reciters) {
      String letter = reciter.data.letter.toUpperCase();

      if (!groupedReciters.containsKey(letter)) {
        groupedReciters[letter] = [];
      }
      groupedReciters[letter]!.add(reciter);
    }

    groupedReciters.forEach((key, value) {
      value.sort((a, b) => a.data.name.compareTo(b.data.name));
    });
    return groupedReciters.entries.toList();
  }

  Future _getMoreLetters() async {
    int remaining = groupedRecitersList.length - displayedGroupes;
    int increase = remaining > 5 ? 5 : remaining;
    setState(() {
      displayedGroupes += increase;
    });
  }

  void _scrollListener() async {
    if (_scrollController?.offset == _scrollController?.position.maxScrollExtent) {
      _getMoreLetters();
    }
  }

  bool _isLongList() {
    return groupedRecitersList.length > 5;
  }
}
