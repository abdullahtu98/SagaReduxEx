import 'package:flutter/foundation.dart';

@immutable
class Question {
  final int id;
  final String question;
  final List<String> answers = [];
  Question({
    required this.id,
    required this.question,
  });
}
