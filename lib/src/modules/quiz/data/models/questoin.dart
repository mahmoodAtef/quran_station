class Question {
  final String questionText;
  final List<String> answers;
  final int trueAnswerIndex;
  final int id;
  int? userAnswer;
  Question(
      {required this.questionText,
      required this.id,
      required this.answers,
      required this.trueAnswerIndex});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
        questionText: json["question_text"],
        answers: List<String>.from(json["answers"]),
        trueAnswerIndex: json["true_answer_index"],
        id: json["question_id"]);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      "question_id": id,
      "question_text": questionText,
      "answers": answers,
      "true_answer_index": trueAnswerIndex
    };
    return data;
  }

  void setAnswer(int answerIndex) {
    userAnswer = answerIndex;
  }

  int getMark() {
    return userAnswer == trueAnswerIndex ? 1 : 0;
  }
}
