import 'dart:io';

import 'package:flutter_app_redux/reducers/Actions.dart';
import 'package:redux_saga/redux_saga.dart';

Iterable mySaga() sync* {
  yield TakeEvery(addQuestionAsync, pattern: CheckConnectionAndAddQuestion);
  yield TakeEvery(addAnswerAsync, pattern: CheckConnectionAndAddAnswer);
}

Iterable addQuestionAsync({dynamic action}) sync* {
  var res = Result();
  yield Call(checkConnection, result: res);
  if (res.value) yield Put(AddQuestion(action.question));
}

Iterable addAnswerAsync({dynamic action}) sync* {
  var res = Result();
  yield Call(checkConnection, result: res);
  if (res.value)
    yield Put(AddAnswer(question: action.question, answer: action.answer));
}

Future<bool> checkConnection() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    } else
      return false;
  } on SocketException catch (_) {
    return false;
  }
}
