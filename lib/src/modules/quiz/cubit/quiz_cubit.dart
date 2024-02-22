import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quran_station/src/modules/quiz/data/data_source/quiz_remote_data_source.dart';
import 'package:quran_station/src/modules/quiz/data/models/questoin.dart';

part 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit() : super(QuizInitial());

  List<Question> qestions = [];
  int? totalMarks;
  Future getQuestions() async {
    QuizRemoteDataSource dataSource = QuizRemoteDataSource();
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

  void answerQuestion(int questionIndex, int answerIndex) {
    qestions[questionIndex].userAnswer = answerIndex;
    emit(AnswerQuestionState());
  }

  void checkUserAnswers() {
    for (var question in qestions) {
      if (question.trueAnswerIndex == question.userAnswer) {
        totalMarks = totalMarks! + 1;
      }
      emit(CheckAnswersState());
    }
  }
}
