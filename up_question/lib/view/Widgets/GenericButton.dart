import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:up_question/model/LocalData.dart';
import 'package:up_question/model/User.dart';
import 'package:up_question/controller/auth.dart';
import 'package:up_question/model/Reply.dart';
import 'package:up_question/model/Question.dart';
import 'package:up_question/model/Talk.dart';

class GenericButton extends StatefulWidget {
  final String textInButton;
  final User user;
  final bool loading;
  final GlobalKey<FormState> _formKey;
  final AuthService _auth;
  final Key key;
  final Function toggleForm;
  final Reply reply;
  final Question question;
  final Talk talk;

  GenericButton(this.textInButton, this.user, this.loading, this._formKey,
      this._auth, this.key, this.toggleForm,this.reply,this.question,this.talk);

  @override
  _GenericButtonState createState() {
    return _GenericButtonState(
        user, textInButton, loading, _formKey, _auth, key, toggleForm,reply,question,talk);
  }
}

class _GenericButtonState extends State<GenericButton> {
  final String textInButton;
  final User user;
  bool loading;
  final GlobalKey<FormState> _formKey;
  final AuthService _auth;
  final Key keyvalue;
  final Function toggleForm;
  final Reply reply;
  final Question question;
  final Talk talk;


  _GenericButtonState(this.user, this.textInButton, this.loading, this._formKey,
      this._auth, this.keyvalue, this.toggleForm,this.reply,this.question,this.talk);

  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Padding(
      key: keyvalue,
      padding: const EdgeInsets.only(bottom: 20),
      child: ButtonTheme(
        minWidth: double.infinity,
        height: 44,
        child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: Color(0xFF353535),
          textColor: Colors.white,
          onPressed: () async {
            final form = _formKey.currentState;

            switch (textInButton) {
              case 'Login':
                if (form.validate()) {
                  form.save();
                  setState(() => loading = true);
                  dynamic result =
                      await _auth.signIn(user.email, user.password);

                  setState(() => loading = false);

                  if (result != null) {
                    if (!result.isEmailVerified)
                      _showDialog(context, 'Please Confirm your Email');
                    else {
                      _showDialog(context, 'Login Successfull');
                      Navigator.pushReplacementNamed(context, '/SchedulePage');
                    }
                  } else {
                    _showDialog(context, 'Login Failed');
                  }
                }

                break;

              case 'Create Your Account':
                if (form.validate()) {
                  form.save();
                  setState(() => loading = true);
                  dynamic result = await _auth.register(
                      user.email, user.username, user.password);

                  setState(() => loading = false);

                  if (result != null) {
                    _showDialog(context, 'Register Successful');
                    widget.toggleForm();
                  } else {
                    _showDialog(context, 'Register Failed');
                  }
                }
                break;

              case 'Share':

                if (form.validate()) {
                  form.save();
                  question.talkRef = talk.talkRef;
                  question.userRef = LocalData.user.userRef;
                  await LocalData.dbReference.addQuestion(question);
                  Navigator.pop(context);
                }
                break;
            }
          },
          child: Text(
            textInButton,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              fontSize: 22,
            ),
          ),
        ),
      ),
    );
  }

  _showDialog(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
