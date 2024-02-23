import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quran_station/src/core/utils/color_manager.dart';
import 'package:quran_station/src/core/utils/styles_manager.dart';
import 'package:quran_station/src/modules/quiz/cubit/quiz_cubit.dart';
import 'package:quran_station/src/modules/quiz/data/models/questoin.dart';
import 'package:sizer/sizer.dart';
import 'package:svg_flutter/svg.dart';

class ProgressBar extends StatelessWidget {
  final int currentQuestion;
  const ProgressBar({super.key, required this.currentQuestion});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 35,
      decoration: BoxDecoration(
        border: Border.all(color: ColorManager.darkBlue, width: 2),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) => Container(
              // from 0 to 1 it takes 60s
              width: constraints.maxWidth * currentQuestion / 20,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  ColorManager.primary.withOpacity(.5),
                  ColorManager.primary.withOpacity(.6),
                  ColorManager.primary,
                ]),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 5.w,
            ),
            child: Center(
              child: Text(
                "$currentQuestion / 20",
                style: TextStylesManager.regularBoldStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  final Question question;

  const QuestionCard({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90.w,
      height: 70.h,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(2.w),
            child: Column(
              children: [
                SizedBox(
                  width: 88.w,
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: Text(
                        question.questionText,
                        maxLines: 5,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return _buildOption(index);
                    },
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: question.answers.length)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOption(int index) {
    QuizCubit cubit = QuizCubit.get();
    return InkWell(
      onTap: () {
        cubit.answerQuestion(question, index);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              width: 86.w,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: _getOptionColor(index, cubit.quizCompleted),
                  border: Border.all(
                    color: ColorManager.black,
                    width: .3,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    if (cubit.quizCompleted)
                      Container(
                        height: 26,
                        width: 10.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: _getOptionIcon(index, cubit.quizCompleted),
                      ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: Text(
                          style: TextStyle(color: _getOptionTextColor(index, cubit.quizCompleted)),
                          question.answers[index],
                          maxLines: 5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getOptionColor(int index, bool quizCompleted) {
    Color color = ColorManager.white;
    if (!quizCompleted) {
      color = index == question.userAnswer ? ColorManager.card : ColorManager.white;
    } else {
      if (question.trueAnswerIndex == index) {
        color = ColorManager.trueAnswer;
      } else if (question.userAnswer != null && question.userAnswer == index) {
        color = ColorManager.error;
      }
    }
    return color;
  }

  Color _getOptionTextColor(int index, bool quizCompleted) {
    return (quizCompleted && question.getMark() == 0 && question.userAnswer == index)
        ? ColorManager.white
        : ColorManager.black;
  }

  Icon? _getOptionIcon(int index, bool quizCompleted) {
    if (quizCompleted) {
      if (question.trueAnswerIndex == index) {
        return const Icon(
          Icons.check_circle,
          color: ColorManager.white,
        );
      } else if (question.userAnswer == index && question.getMark() == 0) {
        return const Icon(
          Icons.cancel,
          color: ColorManager.white,
        );
      }
    }
    return null;
  }
}
