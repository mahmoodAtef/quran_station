import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:quran_station/src/core/utils/color_manager.dart';
import 'package:quran_station/src/core/utils/styles_manager.dart';
import 'package:quran_station/src/modules/audios/presentation/screens/all_reciters_screen.dart';
import 'package:quran_station/src/modules/main/presentation/ui_entities/main_screen_item.dart';
import 'package:quran_station/src/modules/main/presentation/widgets/app_bar.dart';
import 'package:quran_station/src/modules/main/presentation/widgets/components.dart';
import 'package:sizer/sizer.dart';

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
        screen: AllRecitersScreen(),
      ),
      MainScreenItem(
        title: "قراءة",
        icon: Icon(
          Icons.menu_book_rounded,
          size: 35,
        ),
        screen: AllRecitersScreen(),
      ),
      MainScreenItem(
        title: "حفظ القرآن",
        icon: Icon(
          Icons.person,
          size: 35,
        ),
        screen: AllRecitersScreen(),
      ),
      MainScreenItem(
        title: "الملف الشخصي",
        icon: Icon(
          Icons.person,
          size: 35,
        ),
        screen: AllRecitersScreen(),
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
        title: const Text(
          'محطة القرآن الكريم',
          style: TextStylesManager.blackTitle,
        ),
      ),
      drawer: appDrawer,
      body: SingleChildScrollView(
        child: Padding(
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
                    fit: BoxFit.cover,
                    imageUrl:
                        "https://images.pexels.com/photos/7249191/pexels-photo-7249191.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
              ),
              SizedBox(height: 5.h),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemBuilder: (context, index) {
                  return MainScreenItemWidget(
                    item: items[index],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
