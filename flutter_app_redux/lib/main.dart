import 'package:flutter/material.dart';
import 'package:flutter_app_redux/ItemsList.dart';
import 'package:flutter_app_redux/models/AppState.dart';
import 'package:flutter_app_redux/models/Question.dart';
import 'package:flutter_app_redux/reducers/Actions.dart';
import 'package:flutter_app_redux/reducers/reducers.dart';
import 'package:flutter_app_redux/reducers/sagas/saga.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_saga/redux_saga.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SagaMiddleware sagaMiddleware = createSagaMiddleware();
    final Store<AppState> store = Store<AppState>(appStateReducer,
        initialState: AppState.initialState(),
        middleware: [applyMiddleware(sagaMiddleware)]);
    sagaMiddleware.setStore(store);

    sagaMiddleware.run(mySaga);
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.list),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemsListPage(),
                ));
          },
        ),
        title: Text(widget.title),
      ),
      body: StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) => _ViewModel.create(store),
        builder: (context, vm) {
          return Column(
            children: [
              AddQuestionWidget(vm: vm),
              Container(
                height: 600,
                child: ListView(
                  children: vm.questions
                      .map((e) => ListTile(
                            title: Text(e.question),
                            leading: IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content:
                                          StoreConnector<AppState, _AnswerVM>(
                                        converter: (Store<AppState> s) =>
                                            _AnswerVM.create(s, e),
                                        builder: (context, vm) {
                                          TextEditingController con =
                                              new TextEditingController();
                                          return SizedBox(
                                            width: 400,
                                            height: 500,
                                            child: Column(
                                              children: [
                                                AnswerTextField(
                                                  con: con,
                                                  vm: vm,
                                                ),
                                                Container(
                                                  height: 400,
                                                  child: ListView(
                                                    children: e.answers
                                                        .map((e) => ListTile(
                                                              title: Text(e),
                                                              leading: Icon(
                                                                  Icons
                                                                      .ac_unit),
                                                            ))
                                                        .toList(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ))
                      .toList(),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class AnswerTextField extends StatelessWidget {
  const AnswerTextField({Key? key, required this.con, required this.vm})
      : super(key: key);

  final TextEditingController con;
  final _AnswerVM vm;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: con,
      decoration: InputDecoration(hintText: "type an answer"),
      onSubmitted: (value) {
        vm.onAddItem(value);
        con.text = "";
      },
    );
  }
}

class AddQuestionWidget extends StatefulWidget {
  final _ViewModel vm;
  AddQuestionWidget({required this.vm});

  @override
  _AddQuestionWidgetState createState() => _AddQuestionWidgetState();
}

class _AddQuestionWidgetState extends State<AddQuestionWidget> {
  final TextEditingController controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(hintText: "type a question"),
      onSubmitted: (value) {
        widget.vm.onAddItem(value);
        controller.text = "";
      },
    );
  }
}

class _ViewModel {
  final List<Question> questions;
  final Function(String) onAddItem;
  _ViewModel({
    required this.questions,
    required this.onAddItem,
  });
  factory _ViewModel.create(Store<AppState> store) {
    _onAddItem(String question) {
      store.dispatch(CheckConnectionAndAddQuestion(question));
    }

    return _ViewModel(questions: store.state.questions, onAddItem: _onAddItem);
  }
}

class _AnswerVM {
  final Question question;
  final Function(String) onAddItem;
  _AnswerVM({required this.question, required this.onAddItem});
  factory _AnswerVM.create(Store<AppState> store, Question question) {
    _onAddItem(String answer) {
      store.dispatch(
          CheckConnectionAndAddAnswer(question: question, answer: answer));
    }

    return _AnswerVM(question: question, onAddItem: _onAddItem);
  }
}
