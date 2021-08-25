import 'package:flutter_app_redux/models/Question.dart';

class AddQuestion {
  static int _id = 0;
  final String question;
  //final List<String> answers;
  AddQuestion(this.question) {
    _id++;
  }
  int get id => _id;
}

class AddAnswer {
  final Question question;
  final String answer;
  AddAnswer({
    required this.question,
    required this.answer,
  });
}

class CheckConnectionAndAddQuestion {
  final String question;
  //final List<String> answers;
  CheckConnectionAndAddQuestion(this.question);
}

class CheckConnectionAndAddAnswer {
  final Question question;
  final String answer;
  //final List<String> answers;
  CheckConnectionAndAddAnswer({
    required this.question,
    required this.answer,
  });
}
