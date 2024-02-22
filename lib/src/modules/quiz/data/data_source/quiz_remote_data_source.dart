import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:quran_station/src/modules/quiz/data/models/questoin.dart';

class QuizRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<Either<Exception, List<Question>>> getQuiz() async {
    try {
      List<Question> questions = [];
      _firestore.collection("questions");
      int documentCount = await _getDocumentCount();
      int randomStartIndex = _generateRandomIndex(documentCount);
      var collection = _firestore.collection('quran_questions');
      var querySnapshot = await collection
          .orderBy(FieldPath.documentId)
          .startAt([randomStartIndex.toString()])
          .limit(20)
          .get();

      for (var doc in querySnapshot.docs) {
        var questionData = doc.data();
        print("q ${doc.id}):");
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
    int documentCount = await collection.snapshots().length;
    print("num of questions : $documentCount");
    return documentCount;
  }

  int _generateRandomIndex(int documentCount) {
    int randomIndexRange = documentCount - 19;
    int r = Random().nextInt(randomIndexRange);
    print("random number : $r");
    return r;
  }
}
