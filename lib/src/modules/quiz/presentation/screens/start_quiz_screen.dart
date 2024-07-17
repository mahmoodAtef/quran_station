// ignore_for_file: body_might_complete_normally_catch_error

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quran_station/src/core/exceptions/exception_handler.dart';
import 'package:quran_station/src/core/utils/color_manager.dart';
import 'package:quran_station/src/core/utils/navigation_manager.dart';
import 'package:quran_station/src/modules/main/presentation/widgets/components.dart';
import 'package:quran_station/src/modules/quiz/cubit/quiz_cubit.dart';
import 'package:quran_station/src/modules/quiz/presentation/widgets/components.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils/styles_manager.dart';

class StartQuizScreen extends StatelessWidget {
  const StartQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    QuizCubit cubit = QuizCubit.get()..getQuestions();
    ScreenshotController screenshotController = ScreenshotController();
    ScreenshotController resultScreenshotController = ScreenshotController();
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return BlocListener<QuizCubit, QuizState>(
      listener: (context, state) {
        if (state is GetQuizErrorState) {
          ExceptionHandler.handle(state.exception);
        }
      },
      child: BlocBuilder<QuizCubit, QuizState>(
        builder: (context, state) {
          return Screenshot(
            controller: screenshotController,
            child: Scaffold(
              key: scaffoldKey,
              drawer: appDrawer,
              appBar: AppBar(
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
                actions: [
                  if (cubit.state is! GetQuizLoadingState &&
                      cubit.qestions.isNotEmpty)
                    IconButton(
                        tooltip: "مشاركة السؤال",
                        onPressed: () async {
                          await _captureAndShareScreenshot(
                              context,
                              screenshotController,
                              "اختبر معلوماتك في القران الكريم..!");
                        },
                        icon: const Icon(
                          Icons.share,
                          color: ColorManager.black,
                        ))
                ],
              ),
              body: BlocConsumer<QuizCubit, QuizState>(
                  bloc: cubit,
                  builder: (context, state) {
                    return state is GetQuizLoadingState
                        ? const LinearProgressIndicator()
                        : Padding(
                            padding: EdgeInsets.all(5.0.w),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.w),
                                  child: ProgressBar(
                                      currentQuestion: cubit.currentpage + 1),
                                ),
                                Expanded(
                                  child: PageView.builder(
                                      controller: cubit.quizConttoller,
                                      onPageChanged: (index) {
                                        cubit.changeQuestionPage(index);
                                      },
                                      itemCount: cubit.qestions.length,
                                      itemBuilder: (context, index) =>
                                          QuestionCard(
                                            question: cubit.qestions[index],
                                          )),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(2.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            if (cubit.currentpage != 0) {
                                              cubit.changeQuestionPage(
                                                  cubit.currentpage - 1);
                                            }
                                          },
                                          icon: Icon(
                                              color: cubit.currentpage != 0
                                                  ? ColorManager.black
                                                  : ColorManager.grey2,
                                              Icons.arrow_back_ios)),
                                      if (cubit.currentpage == 19 &&
                                          !cubit.quizCompleted)
                                        Expanded(
                                          child: SizedBox(
                                            height: 5.h,
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  cubit.finishQuiz();

                                                  showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return Screenshot(
                                                          controller:
                                                              resultScreenshotController,
                                                          child: AlertDialog(
                                                            elevation: 3,
                                                            actions: [
                                                              TextButton(
                                                                child: const Text(
                                                                    "تحدي الأصدقاء"),
                                                                onPressed:
                                                                    () async {
                                                                  await _captureAndShareScreenshot(
                                                                      context,
                                                                      resultScreenshotController,
                                                                      "هذه نتيجتي في اختبار المعلومات القرآنية. من يتحداني؟");
                                                                },
                                                              ),
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    context
                                                                        .pop();
                                                                  },
                                                                  child: const Text(
                                                                      "مراجعة الاجابات"))
                                                            ],
                                                            content: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                if (cubit
                                                                        .totalMarks >
                                                                    10)
                                                                  const Text(
                                                                      'تهانينا'),
                                                                const Text(
                                                                    'لقد حصلت على '),
                                                                const SizedBox(
                                                                    height: 20),
                                                                Stack(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  children: [
                                                                    SizedBox(
                                                                      width:
                                                                          100,
                                                                      height:
                                                                          100,
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        backgroundColor:
                                                                            ColorManager.grey1,
                                                                        color: ColorManager
                                                                            .primary,
                                                                        value: cubit.totalMarks /
                                                                            20,
                                                                        // تحويل نسبة الدرجة إلى النسبة المطلوبة
                                                                        strokeWidth:
                                                                            10,
                                                                        valueColor:
                                                                            const AlwaysStoppedAnimation<Color>(ColorManager.primary),
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      '${(cubit.totalMarks / 20 * 100).toInt()}%',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              ColorManager.black),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                },
                                                child: const Text(
                                                    "إنهاء الاختبار")),
                                          ),
                                        ),
                                      if (cubit.quizCompleted)
                                        Expanded(
                                          child: SizedBox(
                                            height: 5.h,
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  cubit.restartQuiz();
                                                },
                                                child: const Text(
                                                    "إعادة الاختبار")),
                                          ),
                                        ),
                                      IconButton(
                                          onPressed: () {
                                            if (cubit.currentpage != 19) {
                                              cubit.changeQuestionPage(
                                                  cubit.currentpage + 1);
                                            }
                                          },
                                          icon: Icon(
                                              color: cubit.currentpage != 19
                                                  ? ColorManager.black
                                                  : ColorManager.grey2,
                                              Icons.arrow_forward_ios))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                  },
                  listener: (context, state) async {}),
            ),
          );
        },
      ),
    );
  }

  Future<void> _captureAndShareScreenshot(BuildContext context,
      ScreenshotController screenshotController, String text) async {
    final imageBytes = await screenshotController
        .capture(
      pixelRatio: MediaQuery.of(context).devicePixelRatio,
    )
        .catchError((e) {
      if (kDebugMode) {
        print(e);
      }
    });

    XFile? imageFile = await _convertBytesToXFile(imageBytes!);

    // مشاركة الصورة
    if (imageFile != null) {
      Share.shareXFiles(
        [XFile(imageFile.path)],
        text: text,
      );
    }
  }

  Future<XFile?> _convertBytesToXFile(Uint8List bytes) async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;
    File file = await File('$tempPath/screenshot.png').writeAsBytes(bytes);
    return XFile(file.path);
  }
}
