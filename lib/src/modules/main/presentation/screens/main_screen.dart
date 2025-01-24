import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:quran_station/src/core/utils/color_manager.dart';
import 'package:quran_station/src/core/utils/images_manager.dart';
import 'package:quran_station/src/core/utils/styles_manager.dart';
import 'package:quran_station/src/modules/audios/presentation/screens/audios_main_screen.dart';
import 'package:quran_station/src/modules/main/presentation/ui_entities/main_screen_item.dart';
import 'package:quran_station/src/modules/main/presentation/widgets/components.dart';
import 'package:quran_station/src/modules/quiz/presentation/screens/start_quiz_screen.dart';
import 'package:quran_station/src/modules/reading/presentation/screens/moshaf_screen.dart';
import 'package:sizer/sizer.dart';

import '../../../tajweed/presentation/screens/tajweed_main_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<MainScreenItem> items = const [
      MainScreenItem(
        title: "الصوتيات",
        icon: Icon(
          Icons.headphones,
          size: 35,
        ),
        screen: AudiosMainScreen(),
      ),
      MainScreenItem(
        title: "المصحف",
        icon: Icon(
          Icons.menu_book_rounded,
          size: 35,
        ),
        screen: MoshafScreen(),
      ),
      MainScreenItem(
        title: "التجويد",
        icon: Icon(
          Icons.record_voice_over_outlined,
          size: 35,
        ),
        screen: TajweedMainScreen(),
      ),
      MainScreenItem(
        title: "اختبر نفسك",
        icon: Icon(
          Icons.question_mark,
          size: 35,
        ),
        screen: StartQuizScreen(),
      ),
    ];
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        // height: 10.h,
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
          'كَلَامُ رَبِّي',
          style: TextStylesManager.appBarTitle,
        ),
      ),
      drawer: appDrawer,
      body: Padding(
        padding: EdgeInsets.all(5.0.w),
        child: Column(
          children: [
            Container(
              height: 20.h,
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.sp),
                color: ColorManager.primary,
              ),
              child: CachedNetworkImage(
                  filterQuality: FilterQuality.high,
                  errorWidget: (context, string, error) {
                    return FittedBox(
                      fit: BoxFit.fill,
                      child: Container(
                        color: ColorManager.grey2,
                      ),
                    );
                  },
                  fit: BoxFit.cover,
                  imageUrl: ImagesManager.mainScreenImage),
            ),
            SizedBox(height: 5.h),
            // Expanded(
            //   child: GridView.builder(
            //     shrinkWrap: true,
            //     physics: const NeverScrollableScrollPhysics(),
            //     itemCount: items.length,
            //     gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            //         maxCrossAxisExtent: 200,
            //         childAspectRatio: 1,
            //         crossAxisSpacing: 10,
            //         mainAxisSpacing: 10),
            //     itemBuilder: (context, index) {
            //       return MainScreenItemWidget(
            //         item: items[index],
            //       );
            //     },
            //   ),
            // ),
            Expanded(
              child: StaggeredGrid.count(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  StaggeredGridTile.count(
                      crossAxisCellCount: 2,
                      mainAxisCellCount: 3,
                      child: MainScreenItemWidget(
                        item: items[0],
                        //
                      )),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 2,
                    child: MainScreenItemWidget(
                      item: items[1],
                      //
                    ),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 3,
                    child: MainScreenItemWidget(
                      item: items[2],
                      //
                    ),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 2,
                    child: MainScreenItemWidget(
                      item: items[3],
                      //
                    ),
                  ),
                ],
              ),
            ),
            // const HeightSeparator(),
          ],
        ),
      ),
    );
  }
}
