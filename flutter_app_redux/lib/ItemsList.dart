import 'package:flutter/material.dart';
import 'package:flutter_app_redux/models/AppState.dart';
import 'package:flutter_app_redux/models/Question.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ItemsListPage extends StatefulWidget {
  ItemsListPage({Key? key}) : super(key: key);

  @override
  _ItemsListPageState createState() => _ItemsListPageState();
}

class _ItemsListPageState extends State<ItemsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Items"),
      ),
      body: Center(
        child: StoreConnector<AppState, _VM>(
          converter: (store) => _VM(questions: store.state.questions),
          builder: (context, vm) {
            return Container(
              child: ListView(
                children: vm.questions
                    .map((e) => ListTile(
                          title: Text(e.question),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: SizedBox(
                                  height: 500,
                                  width: 400,
                                  child: Container(
                                    height: 400,
                                    child: ListView(
                                      children: e.answers
                                          .map((e) => ListTile(
                                                title: Text(e),
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ))
                    .toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _VM {
  final List<Question> questions;
  _VM({required this.questions});
}
