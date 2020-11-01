import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sportswatch/client/api/api.dart';
import 'package:sportswatch/client/models/user_model.dart';
import 'package:sportswatch/widgets/buttons/default.dart';
import 'package:sportswatch/widgets/buttons/text_button.dart';
import 'package:sportswatch/widgets/colors/default.dart';
import 'package:sportswatch/widgets/headings/h1.dart';
import 'package:sportswatch/widgets/input/password.dart';
import 'package:sportswatch/widgets/input/text.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({Key key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  Future<UserModel> _response;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: SportsWatchColors.backgroundColor,
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[_buildSignupPage(context)]),
        )
    );
  }

  Widget _buildSignupPage(BuildContext context) {
    return Form(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Heading1('Opret ny bruger'),
              (_response != null) ? FutureBuilder<UserModel>(
                future: _response,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data.email);
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return CircularProgressIndicator();
                },
              ) : Text(''),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              TextInputField(
                hintText: 'Indtast e-mail',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              TextInputField(
                hintText: 'Indtast fornavn',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              TextInputField(
                hintText: 'Indtast efternavn',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              PasswordInputField(
                hintText: 'Indtast adgangskode',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              PasswordInputField(
                hintText: 'Gentag adgangskode',
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: AddButton(
                      text: 'Opret bruger',
                      onPressed: () {
                        setState(() {
                          _response = callApi();
                        });
                      }
                    ),
                  )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Center(
                  child: SimpleTextButton(
                    onPressed: () => jumpLoginPage(),
                    text: 'Allerede oprettet? Login her',
                  ),
                ),
              ),
            ],
        ),
    );
  }

  Future<UserModel> callApi() async {
    return await api.user.post('emwedail@dd.com', 'tobias', 'dybdahl', 'qwerty', 'qwerty');
  }

  void jumpLoginPage() {
    Navigator.pop(context);
  }

}
