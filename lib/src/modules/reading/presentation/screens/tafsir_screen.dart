import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_station/src/modules/reading/cubit/moshaf_cubit.dart';
import 'package:quran_station/src/modules/reading/presentation/pages/tafsir_page.dart';
import 'package:sizer/sizer.dart';

class TafsirScreen extends StatefulWidget {
  const TafsirScreen({Key? key}) : super(key: key);

  @override
  State<TafsirScreen> createState() => _TafsirScreenState();
}

class _TafsirScreenState extends State<TafsirScreen> {
  bool loading = true;
  MoshafCubit cubit = MoshafCubit.get();
  late PageController controller;

  @override
  void initState() {
    _getInitialPage();
    super.initState();
  }

  Future _getInitialPage() async {
    await cubit.loadJsonData();
    setState(() {
      loading = false;
      controller = PageController(initialPage: cubit.currentPage - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "التفسير الميسر",
          style: theme.appBarTheme.titleTextStyle,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<MoshafCubit, MoshafState>(
                bloc: cubit,
                builder: (context, state) {
                  return loading
                      ? const SizedBox()
                      : PageView.builder(
                          itemCount: 604,
                          onPageChanged: (index) {
                            cubit.currentTafsirPage = index + 1;
                          },
                          controller: controller,
                          itemBuilder: (context, index) =>
                              TextTafsirPage(pageNumber: index + 1));
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(2.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        if (cubit.currentTafsirPage != 1) {
                          controller.previousPage(
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.linear);
                        }
                      },
                      icon: Icon(
                          color: cubit.currentTafsirPage != 1
                              ? theme.iconTheme.color
                              : theme.disabledColor,
                          Icons.arrow_back_ios)),
                  IconButton(
                      onPressed: () {
                        if (cubit.currentTafsirPage != 604) {
                          controller.nextPage(
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.linear);
                        }
                      },
                      icon: Icon(
                          color: cubit.currentTafsirPage != 604
                              ? theme.iconTheme.color
                              : theme.disabledColor,
                          Icons.arrow_forward_ios))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
