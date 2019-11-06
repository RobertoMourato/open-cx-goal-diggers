import 'package:flutter/material.dart';
import 'package:up_question/model/Question.dart';
import 'package:up_question/model/Talk.dart';
import 'package:up_question/view/QuestionView.dart';
import 'package:up_question/view/Widgets/QuestionForm.dart';

import '../TalkView.dart';

class QuestionPageView extends StatefulWidget {
  @override
  _QuestionsPageState createState() {
    return _QuestionsPageState();
  }
}

class _QuestionsPageState extends State<QuestionPageView> {
  // TODO:
  /*
  * Testing
  * -----------
  * */
  Talk T = new Talk(
      title: "Internet Security",
      speaker: "John",
      startTime: new DateTime.now(),
      endTime: new DateTime.now(),
      location: "FEUP",
      backgroundImagePath: "assets/images/big_data_back.png");

  static List<Question> questions = <Question>[
    new Question(question: "Sample Question0?"),
    new Question(question: "Sample Question1?"),
    new Question(question: "Sample Question2?"),
    new Question(question: "Sample Question3?"),
    new Question(question: "Sample Question4?"),
    new Question(question: "Sample Question5?"),
    new Question(question: "Sample Question6?")
  ];

  List<String> _options = ['Top', 'Trending', 'New'];
  String _selectedOption = 'Top';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Questions"),
      ),
      body: Column(
        children: <Widget>[
          TalkView(T),
          DropdownButton(
              value: _selectedOption,
              onChanged: (newValue) {
                setState(() {
                  _selectedOption = newValue;
                });
              },
              elevation: 0,
              isDense: true,
              isExpanded: true,
              items: _options.map((option) {
                return DropdownMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(width: 10),
                      new Text(option),
                    ],
                  ),
                  value: option,
                );
              }).toList(),
            ),
          Expanded(
            child: new ListView.builder(
                // TODO: problema, so aparece a seguir depois de adicionar a 2ª
                itemCount: questions.length,
                itemBuilder: (BuildContext context, int index) {
                  return QuestionView(question: questions[index]);
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return QuestionForm(questionList: questions);
              });
        },
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
