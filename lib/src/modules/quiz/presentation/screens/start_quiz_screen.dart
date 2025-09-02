import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quran_station/src/core/exceptions/exception_handler.dart';
import 'package:quran_station/src/core/utils/navigation_manager.dart';
import 'package:quran_station/src/modules/main/presentation/widgets/components.dart';
import 'package:quran_station/src/modules/quiz/cubit/quiz_cubit.dart';
import 'package:quran_station/src/modules/quiz/presentation/widgets/components.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

class StartQuizScreen extends StatelessWidget {
  const StartQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
              drawer: appDrawer(context),
              appBar: AppBar(
                leadingWidth: 10.w,
                leading: IconButton(
                    onPressed: () async {
                      scaffoldKey.currentState!.openDrawer();
                    },
                    icon: Icon(
                      Icons.menu,
                    )),
                centerTitle: true,
                title: Text(
                  'كَلَامُ رَبِّي',
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
                        icon: Icon(
                          Icons.share,
                        ))
                ],
              ),
              body: BlocConsumer<QuizCubit, QuizState>(
                  bloc: cubit,
                  builder: (context, state) {
                    return state is GetQuizLoadingState
                        ? LinearProgressIndicator(
                            color: theme.colorScheme.primary,
                            backgroundColor: theme.colorScheme.surfaceVariant,
                          )
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
                                            questionNumber: index + 1,
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
                                                  ? theme.colorScheme.onSurface
                                                  : theme.colorScheme.onSurface
                                                      .withOpacity(0.3),
                                              Icons.arrow_back_ios)),
                                      if (cubit.currentpage == 19 &&
                                          !cubit.quizCompleted)
                                        Expanded(
                                          child: SizedBox(
                                            height: 5.h,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      theme.colorScheme.primary,
                                                  foregroundColor: theme
                                                      .colorScheme.onPrimary,
                                                ),
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
                                                            backgroundColor: theme
                                                                .dialogBackgroundColor,
                                                            actions: [
                                                              TextButton(
                                                                style: TextButton
                                                                    .styleFrom(
                                                                  foregroundColor: theme
                                                                      .colorScheme
                                                                      .primary,
                                                                ),
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
                                                                  style: TextButton
                                                                      .styleFrom(
                                                                    foregroundColor: theme
                                                                        .colorScheme
                                                                        .primary,
                                                                  ),
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
                                                                  Text(
                                                                      'تهانينا',
                                                                      style: theme
                                                                          .textTheme
                                                                          .titleMedium
                                                                          ?.copyWith(
                                                                        color: theme
                                                                            .colorScheme
                                                                            .primary,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      )),
                                                                Text(
                                                                    'لقد حصلت على ',
                                                                    style: theme
                                                                        .textTheme
                                                                        .bodyLarge
                                                                        ?.copyWith(
                                                                      color: theme
                                                                          .colorScheme
                                                                          .onSurface,
                                                                    )),
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
                                                                        backgroundColor: theme
                                                                            .colorScheme
                                                                            .surfaceVariant,
                                                                        color: theme
                                                                            .colorScheme
                                                                            .primary,
                                                                        value: cubit.totalMarks /
                                                                            20,
                                                                        // تحويل نسبة الدرجة إلى النسبة المطلوبة
                                                                        strokeWidth:
                                                                            10,
                                                                        valueColor: AlwaysStoppedAnimation<Color>(theme
                                                                            .colorScheme
                                                                            .primary),
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      '${(cubit.totalMarks / 20 * 100).toInt()}%',
                                                                      style: theme
                                                                          .textTheme
                                                                          .titleLarge
                                                                          ?.copyWith(
                                                                              fontWeight: FontWeight.bold,
                                                                              color: theme.colorScheme.onSurface),
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
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: theme
                                                      .colorScheme.secondary,
                                                  foregroundColor: theme
                                                      .colorScheme.onSecondary,
                                                ),
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
                                                  ? theme.colorScheme.onSurface
                                                  : theme.colorScheme.onSurface
                                                      .withOpacity(0.3),
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
