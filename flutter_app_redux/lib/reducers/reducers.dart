import 'package:flutter_app_redux/models/AppState.dart';
import 'package:flutter_app_redux/models/Question.dart';
import 'package:flutter_app_redux/reducers/Actions.dart';

AppState appStateReducer(AppState state, action) {
  return AppState(
    questions: questionsReducer(state.questions, action),
  );
}

List<Question> questionsReducer(List<Question> state, action) {
  if (action is AddQuestion) {
    return []
      ..addAll(state)
      ..add(Question(id: action.id, question: action.question));
  }
  if (action is AddAnswer) {
    Question q =
        state.where((element) => element.id == action.question.id).first;
    q.answers.add(action.answer);
    return []..addAll(state);
  }
  return state;
}

