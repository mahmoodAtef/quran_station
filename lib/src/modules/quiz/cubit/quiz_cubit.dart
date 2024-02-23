import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:quran_station/src/modules/quiz/data/data_source/quiz_remote_data_source.dart';
import 'package:quran_station/src/modules/quiz/data/models/questoin.dart';

part 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  static QuizCubit? cubit;
  static QuizCubit get() {
    cubit ??= QuizCubit();
    return cubit!;
  }

  QuizCubit() : super(QuizInitial());

  List<Question> qestions = [];
  int totalMarks = 0;
  int currentpage = 0;
  bool quizCompleted = false;
  Future getQuestions() async {
    if (qestions.isEmpty) {
      quizCompleted = false;
      totalMarks = 0;
      QuizRemoteDataSource dataSource = QuizRemoteDataSource();
      emit(GetQuizLoadingState());
      var response = await dataSource.getQuiz();
      response.fold((l) {
        emit(GetQuizErrorState(l));
      }, (r) {
        qestions.clear();
        qestions = r;
        totalMarks = 0;
        emit(GetQuizSuccessFullState());
      });
    }
  }

  void answerQuestion(Question question, int answerIndex) {
    question.setAnswer(answerIndex);
    emit(AnswerQuestionState());
  }

  void finishQuiz() {
    quizCompleted = true;
    for (var question in qestions) {
      totalMarks = totalMarks + question.getMark();
      emit(QuizFinishedState());
    }
  }

  void changeQuestionPage(int index) {
    if (kDebugMode) {
      print(index + 1);
    }
    currentpage = index;
    emit(ChangePageState());
  }

  Future restartQuiz() async {
    qestions.clear();
    await getQuestions();
  }
}
