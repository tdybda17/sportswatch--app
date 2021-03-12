import 'package:flutter/material.dart';
import 'package:sportswatch/client/models/category_model.dart';
import 'package:sportswatch/client/models/member_model.dart';
import 'package:sportswatch/screens/UploadPopup/popupResponseMessage.dart';
import 'package:sportswatch/screens/UploadPopup/uploadPopup.dart';
import 'package:sportswatch/widgets/alerts/snack_bar.dart';
import 'package:sportswatch/widgets/buttons/default.dart';
import 'package:sportswatch/widgets/buttons/text_button.dart';
import 'package:sportswatch/widgets/colors/default.dart';
import 'package:sportswatch/widgets/layout/app_bar.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class StopwatchScreen extends StatefulWidget {
  _StopwatchScreenState createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  String _startOrStop = "Start";
  int _currentStopWatchTime = 0;
  var _tranieeTest, _categoryTest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(""),
        backgroundColor: SportsWatchColors.backgroundColor,
        body: Center(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _stopwatch(context),
              _startStop(),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _uploadTime(),
                  _resetTime(),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _stopwatch(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: StreamBuilder<int>(
        stream: _stopWatchTimer.rawTime,
        initialData: _stopWatchTimer.rawTime.value,
        builder: (context, snap) {
          final stopwatchValue = snap.data;
          final _displayTime = StopWatchTimer.getDisplayTime(stopwatchValue,
              hours: false, minute: false);

          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  _displayTime,
                  style: const TextStyle(fontSize: 80),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _startStop() {
    return ButtonTheme(
      minWidth: 300,
      height: 300,
      child: RaisedButton(
        color: SportsWatchColors.primary,
        shape: CircleBorder(),
        child: Text(
          _startOrStop,
          style: TextStyle(fontSize: 40),
        ),
        onPressed: () async {
          if (_stopWatchTimer.isRunning) {
            _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
            setState(() {
              _startOrStop = "Start";
              _stopWatchTimer.rawTime
                  .listen((value) => _currentStopWatchTime = value);
            });
          } else {
            _stopWatchTimer.onExecute.add(StopWatchExecute.start);
            setState(() {
              _startOrStop = "Stop";
            });
          }
        },
      ),
    );
  }

  Widget _resetTime() {
    return Padding(
      padding: EdgeInsets.all(2),
      child: RaisedButton(
        color: SportsWatchColors.primary,
        child: Text('Reset'),
        onPressed: () async {
          resetTime();
        },
      ),
    );
  }

  void resetTime() {
    _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
  }

  Widget _uploadTime() {
    return Padding(
      padding: EdgeInsets.all(2),
      child: RaisedButton(
        color: SportsWatchColors.greenColor,
        child: Text('Upload'),
        onPressed: () async {
          uploadBtnFunction();
        },
      ),
    );
  }

  void passSetStateTrainee(value) {
    setState(() {
      _tranieeTest = value;
    });
  }

  void passSetStateCategory(value) {
    setState(() {
      _categoryTest = value;
    });
  }

  void uploadBtnFunction() async {
    //String statusMessage = "";
    //statusMessage =
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return UploadDialog(_currentStopWatchTime);
      },
    ).then((value) {
      if (value != null) {
        PopupReturnMessage returnMessage = value;

        if (returnMessage.success) {
          showSnackBarSuccess(context, returnMessage.message);
        } else {
          showSnackBarError(context, returnMessage.message);
        }
      }
    });
  }
}