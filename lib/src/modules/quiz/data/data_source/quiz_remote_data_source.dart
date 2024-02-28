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
      List<int> randomIndices = _generateRandomIndices(documentCount, 20);
      print(randomIndices);
      var collection = _firestore.collection('quran_questions');
      var querySnapshot = await collection
          .where(
            "question_id",
            whereIn: randomIndices,
          )
          .get();

      for (var doc in querySnapshot.docs) {
        var questionData = doc.data();
        print(questionData);
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
    var aggregateQuery = await collection.get();
    int documentCount = aggregateQuery.docs.length;
    print("num of questions : $documentCount");
    return documentCount;
  }

  List<int> _generateRandomIndices(int documentCount, int count) {
    Set<int> indicesSet = {};
    while (indicesSet.length < count) {
      int randomIndex = Random().nextInt(documentCount) + 1;
      indicesSet.add(randomIndex);
    }
    return indicesSet.toList();
  }
}
