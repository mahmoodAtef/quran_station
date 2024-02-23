part of 'quiz_cubit.dart';

@immutable
abstract class QuizState {}

class QuizInitial extends QuizState {}

class GetQuizLoadingState extends QuizState {}

class GetQuizSuccessFullState extends QuizState {}

class GetQuizErrorState extends QuizState {
  final Exception exception;
  GetQuizErrorState(this.exception);
}

class AnswerQuestionState extends QuizState {}

class QuizFinishedState extends QuizState {}

class ChangePageState extends QuizState {}
