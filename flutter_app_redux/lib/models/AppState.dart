import 'package:flutter/foundation.dart';
import 'package:flutter_app_redux/models/Question.dart';

@immutable
class AppState {
  final List<Question> questions;

  AppState({required this.questions});

  AppState.initialState() : questions = <Question>[];
 
}
