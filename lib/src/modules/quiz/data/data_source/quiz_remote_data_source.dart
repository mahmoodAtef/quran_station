import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:quran_station/src/modules/quiz/data/models/questoin.dart';

class QuizRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<Either<Exception, List<Question>>> getQuiz() async {
    try {
      List<Question> questions = [];
      int documentCount = await _getDocumentCount();
      int randomStartIndex = _generateRandomIndex(documentCount);
      var collection = _firestore.collection('quran_questions');
      var querySnapshot = await collection
          .where("question_id",
              isGreaterThanOrEqualTo: randomStartIndex, isLessThan: randomStartIndex + 20)
          .get();
      for (var doc in querySnapshot.docs) {
        var questionData = doc.data();
        var question = Question.fromJson(questionData);
        questions.add(question);
      }

      return Right(questions);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  Future<int> _getDocumentCount() async {
    var collection = _firestore.collection('quran_questions');
    var agregateQuery = await collection.count().get();
    int documentCount = agregateQuery.count!;
    print("num of questions : $documentCount");
    return documentCount;
  }

  int _generateRandomIndex(int documentCount) {
    int randomIndexRange = documentCount - 19;
    int r = Random().nextInt(
      randomIndexRange,
    );
    print("random number : $r");
    return r == 0 ? 1 : r;
  }
}
