import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:quran/quranText.dart';
import 'package:quran_station/src/core/utils/color_manager.dart';
import 'package:quran_station/src/modules/main/presentation/widgets/app_bar.dart';
import 'package:quran_station/src/modules/main/presentation/widgets/components.dart';
import 'package:sizer/sizer.dart';
import 'package:quran/quran.dart';

class MoshafScreen extends StatelessWidget {
  const MoshafScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PdfDocument document = PdfDocument();

    return Scaffold(
        drawer: appDrawer,
        appBar: CustomAppBar(
          height: 1.h,
        ),
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
    String jsonString = await rootBundle.loadString("assets/hafs_smart_v8.json");
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
      child: Text(
        maxLines: 15,
        _getQuranTextForPage(widget.pageNumber),
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: "hafs", fontSize: 15.sp),
      ),
    );
  }
}
