import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_station/src/core/utils/color_manager.dart';
import 'package:quran_station/src/core/utils/navigation_manager.dart';
import 'package:quran_station/src/core/utils/styles_manager.dart';
import 'package:quran_station/src/modules/reading/cubit/moshaf_cubit.dart';
import 'package:quran_station/src/modules/reading/presentation/screens/juz_index_screen.dart';
import 'package:quran_station/src/modules/reading/presentation/screens/quran_virtue_screen.dart';
import 'package:quran_station/src/modules/reading/presentation/screens/surahs_index_screen.dart';
import 'package:quran_station/src/modules/reading/presentation/screens/tafsir_screen.dart';
import 'package:sizer/sizer.dart';

import '../pages/quran_page.dart';

class MoshafScreen extends StatefulWidget {
  const MoshafScreen({Key? key}) : super(key: key);

  @override
  State<MoshafScreen> createState() => _MoshafScreenState();
}

class _MoshafScreenState extends State<MoshafScreen> {
  bool _showPageData = false;
  bool _showMenu = false;
  bool loading = true;
  MoshafCubit cubit = MoshafCubit.get();
  @override
  void initState() {
    _getInitialPage();
    super.initState();
  }

  Future _getInitialPage() async {
    await cubit.getInitialPage();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ColorManager.black,
        child: SafeArea(
          child: BlocBuilder<MoshafCubit, MoshafState>(
            bloc: cubit,
            builder: (context, state) {
              return loading
                  ? const SizedBox()
                  : Stack(
                      children: [
                        Positioned.fill(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _showPageData = !_showPageData;
                              });
                            },
                            child: PageView.builder(
                              onPageChanged: (page) {
                                cubit.currentPage = page + 1;
                              },
                              controller: cubit.controller,
                              itemCount: 604,
                              itemBuilder: (context, index) {
                                cubit.getCurrentPageData();
                                return ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                        ColorManager.darkBlue.withOpacity(.7), BlendMode.dst),
                                    child: QuranPage(pageNumber: index + 1));
                              },
                            ),
                          ),
                        ),
                        if (_showPageData)
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 5.h,
                                      width: 100.w,
                                      color: ColorManager.black.withOpacity(.7),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _showMenu = !_showMenu;
                                                  });
                                                },
                                                icon: const Icon(
                                                  Icons.menu,
                                                  color: ColorManager.white,
                                                )),
                                            InkWell(
                                              onTap: () {
                                                context.push(const TafsirScreen());
                                              },
                                              child: const Text(
                                                "التفسير الميسر",
                                                style: TextStylesManager.regularBoldWhiteStyle,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (_showMenu)
                                      Container(
                                        height: 25.h,
                                        width: 40.w,
                                        color: ColorManager.black.withOpacity(.7),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    context.push(const SurahsIndexScreen());
                                                  },
                                                  child: const Text(
                                                    "فهرس السور",
                                                    style: TextStylesManager.regularBoldWhiteStyle,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    context.push(const JuzIndexScreen());
                                                  },
                                                  child: const Text(
                                                    "الأجزاء",
                                                    style: TextStylesManager.regularBoldWhiteStyle,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    _showPageSearchDialog(context);
                                                  },
                                                  child: const Text(
                                                    "البحث عن صفحة",
                                                    style: TextStylesManager.regularBoldWhiteStyle,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    context.push(const ReadingQuranVirtueScreen());
                                                  },
                                                  child: const Text(
                                                    "فضل القرآن",
                                                    style: TextStylesManager.regularBoldWhiteStyle,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        if (_showPageData)
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 5.h,
                              width: 100.w,
                              color: ColorManager.black.withOpacity(.7),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "الجزء ${cubit.currentJuz}",
                                      style: TextStylesManager.regularBoldWhiteStyle,
                                    ),
                                    Text(
                                      "${cubit.currentPage}",
                                      style: TextStylesManager.regularBoldWhiteStyle,
                                    ),
                                    Text(
                                      "سورة ${cubit.currentSura}",
                                      style: TextStylesManager.regularBoldWhiteStyle,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    cubit.saveCurrentPage();
    super.dispose();
  }

  void _showPageSearchDialog(BuildContext context) {
    TextEditingController _pageController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('ابحث عن صفحة'),
          content: TextField(
            controller: _pageController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: 'رقم الصفحة',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.sp))),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                int pageNumber = int.tryParse(_pageController.text) ?? 1;
                if (pageNumber >= 1 && pageNumber <= 604) {
                  cubit.controller.jumpToPage(pageNumber - 1);
                  cubit.currentPage = pageNumber;
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('الرجاء إدخال رقم صفحة صالح بين 1 و 604'),
                    ),
                  );
                }
              },
              child: const Text('انتقل'),
            ),
          ],
        );
      },
    );
  }
}
