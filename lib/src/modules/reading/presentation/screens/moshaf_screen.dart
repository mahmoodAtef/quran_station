import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:quran_station/src/modules/main/presentation/widgets/app_bar.dart';
import 'package:quran_station/src/modules/main/presentation/widgets/components.dart';
import 'package:sizer/sizer.dart';

class MoshafScreen extends StatelessWidget {
  const MoshafScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PdfDocument document = PdfDocument();

    return Scaffold(
        drawer: appDrawer,
        body: SizedBox(
          height: 100.h,
          width: 100.w,
          child: Center(
            child: PageView.builder(
                itemCount: 604, itemBuilder: (context, index) => QuranPage(pageNumber: index + 1)),
          ),
        ));
  }
}

class QuranPage extends StatefulWidget {
  int pageNumber;
  QuranPage({super.key, required this.pageNumber});
  @override
  _QuranPageState createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  List<dynamic> _quranData = [];

  @override
  void initState() {
    super.initState();
    _loadQuranData();
  }

  Future<void> _loadQuranData() async {
    String jsonString = await rootBundle.loadString("assets/quran_data/hafs_smart_v8.json");
    setState(() {
      _quranData = json.decode(jsonString);
    });
  }

  String _getQuranTextForPage(int pageNumber) {
    String text = "";
    for (var verse in _quranData) {
      print(verse);
      if (verse['page'] == pageNumber) {
        text = text + verse["aya_text"].toString();
      }
    }
    print(text);
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.w),
      child: SizedBox(
        height: 90.h,
        width: double.infinity,
        child: TextDividerWidget(text: _getQuranTextForPage(widget.pageNumber)),
      ),
    );
  }

  // String withExtraNextLineCharacters(String text, int count) {
  //   String nextLineCharacters = "";
  //   for (int index = 0; index < (count - 1); index++) {
  //     nextLineCharacters += "\n";
  //   }
  //   return text + nextLineCharacters;
  // }

  String splitTextIntoLines(String text, int maxLines) {
    List<String> lines = [];
    List<String> words = text.split(' ');

    String line = '';
    for (String word in words) {
      if ((line + word).length > 70) {
        // Assuming a maximum line length of 30 characters
        lines.add(line.trim());
        line = '';
        if (lines.length == maxLines) break;
      }
      line += (line.isNotEmpty ? ' ' : '') + word;
    }

    if (line.isNotEmpty) {
      lines.add(line.trim());
    }

    return lines.join('\n');
  }
}

class TextDividerWidget extends StatelessWidget {
  final String text;

  TextDividerWidget({required this.text});

  @override
  Widget build(BuildContext context) {
    List<String> words = text.split(' ');
    List<String> lines = [];
    int wordsPerLine = (words.length / 15).ceil();

    for (int i = 0; i < words.length; i += wordsPerLine) {
      int end = i + wordsPerLine;
      if (end > words.length) end = words.length;
      lines.add(words.sublist(i, end).join(' '));
    }

    return SafeArea(
      child: Text(
        textAlign: TextAlign.justify,
        lines.join(
          " ",
        ),
        style: TextStyle(
          fontSize: 22,
          fontFamily: "hafs",
        ),
      ),
    );
  }
}
